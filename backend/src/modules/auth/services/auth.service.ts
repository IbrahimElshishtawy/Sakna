import { Injectable, Inject, HttpException, HttpStatus, BadRequestException, ConflictException, UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';
import { UserRepository } from '../repositories/user.repository';
import { UserEntity } from '../entities/user.entity';
import { OtpService } from './otp.service';
import { SessionService } from './session.service';
import { SocialAuthService } from './social-auth.service';
import { AUTH_REPOSITORY } from '../constants/auth.constants';

@Injectable()
export class AuthService {
  private readonly passwordResetSecret = process.env.JWT_PASSWORD_RESET_SECRET || 'super_secure_password_reset_secret_123';
  private readonly emailVerificationSecret = process.env.JWT_EMAIL_VERIFICATION_SECRET || 'super_secure_email_verification_secret_123';

  constructor(
    @Inject(AUTH_REPOSITORY)
    private readonly userRepository: UserRepository,
    private readonly otpService: OtpService,
    private readonly sessionService: SessionService,
    private readonly socialAuthService: SocialAuthService,
  ) {}

  async register(
    dto: any,
    deviceName: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    // 1. Verify phone verification token
    try {
      const decoded = jwt.verify(dto.verification_token, this.otpService.getVerificationSecret()) as any;
      if (decoded.phone !== dto.phone || decoded.countryCode !== dto.country_code) {
        throw new BadRequestException('Verification token details mismatch');
      }
    } catch {
      throw new BadRequestException('Invalid or expired verification token');
    }

    // 2. Validate triple name
    const parts = dto.name.trim().split(/\s+/);
    if (parts.length < 3) {
      throw new BadRequestException('Full name must be at least three parts (اسم ثلاثي على الأقل)');
    }

    // 3. Check duplicate
    const existing = await this.userRepository.findByEmailOrPhone(dto.email, dto.phone, dto.country_code);
    if (existing) {
      throw new ConflictException('Email or phone number is already registered');
    }

    // 4. Hash password
    const passwordHash = bcrypt.hashSync(dto.password, 12);

    // 5. Create email verification token (valid for 24h)
    const emailVerificationToken = jwt.sign(
      { email: dto.email },
      this.emailVerificationSecret,
      { expiresIn: '24h' },
    );
    const emailVerificationExpires = new Date(Date.now() + 24 * 60 * 60 * 1000);

    const user = new UserEntity({
      id: `usr_${Math.random().toString(36).substring(7)}`,
      name: dto.name,
      email: dto.email,
      phone: dto.phone,
      countryCode: dto.country_code,
      passwordHash,
      isProfileComplete: false,
      isEmailVerified: false,
      emailVerificationToken,
      emailVerificationExpires,
    });

    const savedUser = await this.userRepository.save(user);

    // 6. Create initial device session
    const tokens = await this.sessionService.createSession(
      savedUser.id,
      'USER',
      deviceName,
      ipAddress,
      userAgent,
    );

    return { user: savedUser, tokens };
  }

  async login(
    dto: any,
    deviceName: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    let user: UserEntity | null = null;

    if (dto.login_field.includes('@')) {
      user = await this.userRepository.findByEmail(dto.login_field);
    } else {
      user = await this.userRepository.findByPhone(dto.login_field, dto.country_code || '');
    }

    if (!user) {
      throw new UnauthorizedException('Invalid login credentials');
    }

    if (!user.passwordHash) {
      throw new UnauthorizedException('Account associated with social login. Use Google/Facebook.');
    }

    const isValid = bcrypt.compareSync(dto.password, user.passwordHash);
    if (!isValid) {
      throw new UnauthorizedException('Invalid login credentials');
    }

    const tokens = await this.sessionService.createSession(
      user.id,
      'USER',
      deviceName,
      ipAddress,
      userAgent,
    );

    return { user, tokens };
  }

  async socialLogin(
    dto: any,
    deviceName: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ user: UserEntity; tokens: { access_token: string; refresh_token: string } }> {
    let payload: any;
    if (dto.provider === 'google') {
      payload = await this.socialAuthService.verifyGoogleToken(dto.social_token);
    } else {
      payload = await this.socialAuthService.verifyFacebookToken(dto.social_token);
    }

    let user = await this.userRepository.findByEmail(payload.email);

    if (user) {
      // Update social credentials if not set
      if (!user.socialProvider) {
        user.socialProvider = dto.provider;
        user.socialToken = dto.social_token;
        if (payload.avatarUrl && !user.avatarUrl) {
          user.avatarUrl = payload.avatarUrl;
        }
        await this.userRepository.update(user.id, {
          socialProvider: dto.provider,
          socialToken: dto.social_token,
          avatarUrl: user.avatarUrl,
        });
      }
    } else {
      // Register new social login user (incomplete profile, phone null)
      user = new UserEntity({
        id: `usr_${Math.random().toString(36).substring(7)}`,
        name: payload.name,
        email: payload.email,
        phone: null,
        countryCode: null,
        passwordHash: null,
        avatarUrl: payload.avatarUrl || null,
        socialProvider: dto.provider,
        socialToken: dto.social_token,
        isProfileComplete: false,
        isEmailVerified: true, // Social accounts verified from google/meta APIs
      });
      user = await this.userRepository.save(user);
    }

    const tokens = await this.sessionService.createSession(
      user.id,
      'USER',
      deviceName,
      ipAddress,
      userAgent,
    );

    return { user, tokens };
  }

  async completeProfile(
    userId: string,
    dto: any,
    avatarUrl?: string,
  ): Promise<UserEntity> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    // Secure phone binding for social SSO logins
    if (!user.phone) {
      if (!dto.phone || !dto.country_code || !dto.verification_token) {
        throw new BadRequestException('Linking a verified phone number is required to complete this profile');
      }

      // Verify OTP verification token
      try {
        const decoded = jwt.verify(dto.verification_token, this.otpService.getVerificationSecret()) as any;
        if (decoded.phone !== dto.phone || decoded.countryCode !== dto.country_code) {
          throw new BadRequestException('Verification token details mismatch');
        }
      } catch {
        throw new BadRequestException('Invalid or expired verification token');
      }

      // Unique check
      const duplicate = await this.userRepository.findByEmailOrPhone('', dto.phone, dto.country_code);
      if (duplicate && duplicate.id !== user.id) {
        throw new ConflictException('This phone number is already linked to another account');
      }

      user.phone = dto.phone;
      user.countryCode = dto.country_code;
    }

    user.gender = dto.gender;
    user.dob = dto.dob;
    user.offersEnabled = dto.offers_enabled === 'true' || dto.offers_enabled === true;
    if (avatarUrl) {
      user.avatarUrl = avatarUrl;
    }
    user.isProfileComplete = true;

    return this.userRepository.save(user);
  }

  async forgotPassword(phone: string, countryCode: string, channel: 'sms' | 'whatsapp'): Promise<any> {
    // Confirm user exists with this phone number
    const user = await this.userRepository.findByEmailOrPhone('', phone, countryCode);
    if (!user) {
      throw new HttpException('Phone number is not registered', HttpStatus.NOT_FOUND);
    }

    // Trigger secure OTP send
    return this.otpService.sendOtp(phone, countryCode, channel);
  }

  async verifyPasswordOtp(
    phone: string,
    countryCode: string,
    otpCode: string,
    sessionId: string,
  ): Promise<{ password_reset_token: string }> {
    // 1. Verify standard OTP code
    await this.otpService.verifyOtp(sessionId, phone, countryCode, otpCode);

    // 2. Generate a highly secure single-use Password Reset Token signed by backend secret (expires in 15m)
    const passwordResetToken = jwt.sign(
      { phone, countryCode, action: 'RESET_PASSWORD' },
      this.passwordResetSecret,
      { expiresIn: '15m' },
    );

    // 3. Update user model
    const user = await this.userRepository.findByEmailOrPhone('', phone, countryCode);
    if (user) {
      await this.userRepository.update(user.id, {
        passwordResetToken,
        passwordResetExpires: new Date(Date.now() + 15 * 60 * 1000),
      });
    }

    return { password_reset_token: passwordResetToken };
  }

  async resetPassword(dto: any): Promise<void> {
    let decoded: any;
    try {
      decoded = jwt.verify(dto.password_reset_token, this.passwordResetSecret);
    } catch {
      throw new BadRequestException('Invalid or expired password reset token');
    }

    const { phone, countryCode } = decoded;

    const user = await this.userRepository.findByEmailOrPhone('', phone, countryCode);
    if (!user || user.passwordResetToken !== dto.password_reset_token) {
      throw new BadRequestException('Token has already been used or user not found');
    }

    if (user.passwordResetExpires && user.passwordResetExpires.getTime() < Date.now()) {
      throw new BadRequestException('Reset token has expired');
    }

    // Hash new password
    const passwordHash = bcrypt.hashSync(dto.new_password, 12);

    // Clear reset tokens & update password
    await this.userRepository.update(user.id, {
      passwordHash,
      passwordResetToken: null,
      passwordResetExpires: null,
    });

    // Enforce high security: invalidate all active login sessions on password change
    await this.sessionService.logoutAll(user.id);
  }

  async sendEmailVerification(userId: string): Promise<void> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const emailVerificationToken = jwt.sign(
      { email: user.email },
      this.emailVerificationSecret,
      { expiresIn: '24h' },
    );
    const emailVerificationExpires = new Date(Date.now() + 24 * 60 * 60 * 1000);

    await this.userRepository.update(userId, {
      emailVerificationToken,
      emailVerificationExpires,
    });

    // Mock Email Verification Simulator
    console.log(`
==================================================
📧 SAKNA EMAIL VERIFICATION SIMULATOR
==================================================
Recipient: ${user.email}
Link:      http://localhost:3000/api/v1/auth/email/verify?token=${emailVerificationToken}
==================================================
`);
  }

  async verifyEmail(token: string): Promise<void> {
    let decoded: any;
    try {
      decoded = jwt.verify(token, this.emailVerificationSecret);
    } catch {
      throw new BadRequestException('Invalid or expired email verification token');
    }

    const user = await this.userRepository.findByEmail(decoded.email);
    if (!user || user.emailVerificationToken !== token) {
      throw new BadRequestException('Token is invalid or has already been used');
    }

    if (user.emailVerificationExpires && user.emailVerificationExpires.getTime() < Date.now()) {
      throw new BadRequestException('Verification token has expired');
    }

    await this.userRepository.update(user.id, {
      isEmailVerified: true,
      emailVerificationToken: null,
      emailVerificationExpires: null,
    });
  }

  async getUserById(id: string): Promise<UserEntity | null> {
    return this.userRepository.findById(id);
  }
}
