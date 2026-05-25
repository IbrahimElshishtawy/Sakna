import { Injectable, Inject, HttpException, HttpStatus } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';
import { IAuthRepository, AUTH_REPOSITORY } from '../domain/auth.repository.interface';
import { UserEntity } from '../domain/user.entity';
import { OtpEntity } from '../domain/otp.entity';
import { SendOtpDto } from './dto/send-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { SocialLoginDto } from './dto/social-login.dto';
import { OtpDeliveryService } from '../infrastructure/otp-delivery.service';
import { RateLimiterService } from '../infrastructure/rate-limiter.service';
import { JwtService } from '../infrastructure/jwt.service';

@Injectable()
export class AuthUseCase {
  private readonly verificationSecret = process.env.JWT_VERIFICATION_SECRET || 'super_secure_verification_secret_123';

  constructor(
    @Inject(AUTH_REPOSITORY)
    private readonly authRepository: IAuthRepository,
    private readonly otpDeliveryService: OtpDeliveryService,
    private readonly rateLimiterService: RateLimiterService,
    private readonly jwtService: JwtService,
  ) {}

  async sendOtp(dto: SendOtpDto): Promise<{ session_id: string; channel: 'sms' | 'whatsapp'; expires_in: number }> {
    const channel = dto.channel || 'sms';

    // 1. Enforce rate limiting: max 3 requests per 10 minutes
    await this.rateLimiterService.checkRateLimit(dto.phone, dto.country_code);

    // 2. Generate a 6-digit random OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

    // 3. Set expiration to 120 seconds (2 minutes)
    const expiresAt = new Date(Date.now() + 120 * 1000);

    // 4. Save to repository
    const otp = new OtpEntity({
      phone: dto.phone,
      countryCode: dto.country_code,
      otpCode,
      expiresAt,
      channel,
    });
    const savedOtp = await this.authRepository.saveOtp(otp);

    // 5. Send OTP via delivery channel
    await this.otpDeliveryService.sendOtp(dto.phone, dto.country_code, otpCode, channel);

    return {
      session_id: savedOtp.sessionId,
      channel: savedOtp.channel,
      expires_in: 120,
    };
  }

  async verifyOtp(dto: VerifyOtpDto): Promise<{ verification_token: string }> {
    const otp = await this.authRepository.findOtpBySession(dto.session_id);

    if (!otp) {
      throw new HttpException('Invalid OTP session', HttpStatus.BAD_REQUEST);
    }

    if (otp.phone !== dto.phone || otp.countryCode !== dto.country_code) {
      throw new HttpException('OTP details mismatch', HttpStatus.BAD_REQUEST);
    }

    const now = new Date();
    if (otp.isExpired(now)) {
      throw new HttpException('OTP code has expired (2 minutes limit)', HttpStatus.BAD_REQUEST);
    }

    if (otp.isVerified) {
      throw new HttpException('OTP has already been verified', HttpStatus.BAD_REQUEST);
    }

    if (otp.attempts >= 3) {
      throw new HttpException('Too many incorrect attempts. Please request a new OTP.', HttpStatus.BAD_REQUEST);
    }

    if (otp.otpCode !== dto.otp_code) {
      otp.incrementAttempts();
      await this.authRepository.updateOtp(otp.sessionId, { attempts: otp.attempts });
      throw new HttpException(`Incorrect OTP code. Attempts left: ${3 - otp.attempts}`, HttpStatus.BAD_REQUEST);
    }

    // Mark as verified
    otp.isVerified = true;
    await this.authRepository.updateOtp(otp.sessionId, { isVerified: true });

    // Generate secure verification token signed with a verification secret
    const verificationToken = jwt.sign(
      {
        phone: dto.phone,
        countryCode: dto.country_code,
        verified: true,
      },
      this.verificationSecret,
      { expiresIn: '15m' },
    );

    return { verification_token: verificationToken };
  }

  async register(dto: RegisterDto): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    // 1. Verify that verification_token is valid and contains matching phone and country code
    try {
      const decoded = jwt.verify(dto.verification_token, this.verificationSecret) as {
        phone: string;
        countryCode: string;
        verified: boolean;
      };

      if (decoded.phone !== dto.phone || decoded.countryCode !== dto.country_code || !decoded.verified) {
        throw new HttpException('Verification token does not match the provided phone details', HttpStatus.BAD_REQUEST);
      }
    } catch {
      throw new HttpException('Invalid or expired verification token. Please verify your phone number again.', HttpStatus.BAD_REQUEST);
    }

    // 2. Validate full name: must have at least 3 parts (words)
    const nameParts = dto.name.trim().split(/\s+/);
    if (nameParts.length < 3) {
      throw new HttpException('Full name must contain at least three parts (اسم ثلاثي على الأقل)', HttpStatus.BAD_REQUEST);
    }

    // 3. Check duplicate user
    const existingUser = await this.authRepository.findUserByEmailOrPhone(dto.email, dto.phone, dto.country_code);
    if (existingUser) {
      throw new HttpException('Email or phone number is already registered', HttpStatus.CONFLICT);
    }

    // 4. Hash password
    const passwordHash = bcrypt.hashSync(dto.password, 10);

    // 5. Create user
    const user = new UserEntity({
      name: dto.name,
      phone: dto.phone,
      countryCode: dto.country_code,
      email: dto.email,
      passwordHash,
      isProfileComplete: false,
    });

    const savedUser = await this.authRepository.createUser(user);

    // 6. Generate JWT Session Tokens
    const tokens = this.generateSessionTokens(savedUser);

    return { user: savedUser, tokens };
  }

  async login(dto: LoginDto): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    let user: UserEntity | null = null;

    if (dto.login_field.includes('@')) {
      user = await this.authRepository.findUserByEmail(dto.login_field);
    } else {
      // Treat as phone login
      // Search users matching phone directly (email argument is left empty to match only phone)
      user = await this.authRepository.findUserByEmailOrPhone('', dto.login_field, '');
    }

    if (!user) {
      throw new HttpException('Invalid login credentials', HttpStatus.UNAUTHORIZED);
    }

    if (!user.passwordHash) {
      throw new HttpException('This account was created via social login. Please sign in with Google or Facebook.', HttpStatus.UNAUTHORIZED);
    }

    const isPasswordValid = bcrypt.compareSync(dto.password, user.passwordHash);
    if (!isPasswordValid) {
      throw new HttpException('Invalid login credentials', HttpStatus.UNAUTHORIZED);
    }

    const tokens = this.generateSessionTokens(user);

    return { user, tokens };
  }

  async socialLogin(dto: SocialLoginDto): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    let user = await this.authRepository.findUserByEmail(dto.email);

    if (user) {
      // User exists. Update social link if not present.
      if (!user.socialProvider) {
        user.socialProvider = dto.provider;
        user.socialToken = dto.social_token;
        if (dto.avatar_url && !user.avatarUrl) {
          user.avatarUrl = dto.avatar_url;
        }
        user = await this.authRepository.updateUser(user.id, {
          socialProvider: dto.provider,
          socialToken: dto.social_token,
          avatarUrl: user.avatarUrl,
        });
      }
    } else {
      // User doesn't exist. Register them as incomplete profile.
      user = new UserEntity({
        name: dto.name,
        email: dto.email,
        phone: null,
        countryCode: null,
        passwordHash: null,
        avatarUrl: dto.avatar_url || null,
        socialProvider: dto.provider,
        socialToken: dto.social_token,
        isProfileComplete: false,
      });
      user = await this.authRepository.createUser(user);
    }

    const tokens = this.generateSessionTokens(user);

    return { user, tokens };
  }

  async completeProfile(
    userId: string,
    gender: 'MALE' | 'FEMALE',
    dob: string,
    offersEnabled: boolean,
    avatarUrl?: string,
  ): Promise<UserEntity> {
    const user = await this.authRepository.findUserById(userId);
    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    user.completeProfile({ gender, dob, offersEnabled, avatarUrl });
    const updatedUser = await this.authRepository.updateUser(userId, user);

    return updatedUser;
  }

  async checkSession(userId: string): Promise<UserEntity> {
    const user = await this.authRepository.findUserById(userId);
    if (!user) {
      throw new HttpException('Session is invalid or user not found', HttpStatus.UNAUTHORIZED);
    }
    return user;
  }

  private generateSessionTokens(user: UserEntity) {
    const access_token = this.jwtService.generateAccessToken({ userId: user.id, email: user.email });
    const refresh_token = this.jwtService.generateRefreshToken({ userId: user.id });
    return { access_token, refresh_token };
  }
}
