import { Injectable, HttpException, HttpStatus, Logger, Inject } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';
import { OtpRepository } from '../repositories/otp.repository';
import { OtpSessionEntity } from '../entities/otp-session.entity';
import {
  OTP_REPOSITORY,
  OTP_EXPIRATION_TIME_SECONDS,
  OTP_MAX_ATTEMPTS,
  OTP_BAN_DURATION_MINUTES,
  OTP_TIME_WINDOW_MINUTES,
  OTP_MAX_REQUESTS_IN_WINDOW,
} from '../constants/auth.constants';

@Injectable()
export class OtpService {
  private readonly logger = new Logger('OtpService');
  private readonly verificationSecret = process.env.JWT_VERIFICATION_SECRET || 'super_secure_verification_secret_123';

  constructor(
    @Inject(OTP_REPOSITORY)
    private readonly otpRepository: OtpRepository,
  ) {}

  async sendOtp(
    phone: string,
    countryCode: string,
    channel: 'sms' | 'whatsapp' = 'sms',
  ): Promise<{ session_id: string; channel: 'sms' | 'whatsapp'; expires_in: number }> {
    // 1. Check if phone is currently banned
    const activeBan = await this.otpRepository.findActiveBanByPhone(phone, countryCode);
    if (activeBan && activeBan.bannedUntil) {
      const minutesLeft = Math.ceil((activeBan.bannedUntil.getTime() - Date.now()) / 60000);
      throw new HttpException(
        `This number is temporarily banned. Try again in ${minutesLeft} minutes.`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    // 2. Check rate limit window
    const timeWindowMs = OTP_TIME_WINDOW_MINUTES * 60 * 1000;
    const recentOtps = await this.otpRepository.findLastOtpsByPhone(phone, countryCode, timeWindowMs);
    
    if (recentOtps.length >= OTP_MAX_REQUESTS_IN_WINDOW) {
      // Apply temporary ban
      const bannedUntil = new Date(Date.now() + OTP_BAN_DURATION_MINUTES * 60 * 1000);
      
      const newBanSession = new OtpSessionEntity({
        id: `ban_sess_${Math.random().toString(36).substring(7)}`,
        phone,
        countryCode,
        otpHash: 'BANNED',
        expiresAt: bannedUntil,
        isVerified: false,
        channel,
        attempts: 0,
        bannedUntil,
      });
      await this.otpRepository.save(newBanSession);

      throw new HttpException(
        `Too many OTP requests. Phone number banned for ${OTP_BAN_DURATION_MINUTES} minutes.`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    // 3. Generate 6-digit random OTP
    const rawOtp = Math.floor(100000 + Math.random() * 900000).toString();
    
    // 4. Hash OTP before saving for high security
    const otpHash = bcrypt.hashSync(rawOtp, 10);
    const expiresAt = new Date(Date.now() + OTP_EXPIRATION_TIME_SECONDS * 1000);
    const sessionId = `otp_sess_${Math.random().toString(36).substring(7)}`;

    const otpSession = new OtpSessionEntity({
      id: sessionId,
      phone,
      countryCode,
      otpHash,
      expiresAt,
      isVerified: false,
      channel,
      attempts: 0,
    });
    
    await this.otpRepository.save(otpSession);

    // 5. Send OTP Simulator (Console log)
    const recipient = `${countryCode}${phone}`;
    this.logger.log(`
==================================================
🔒 SAKNA OTP DELIVERY SIMULATOR (ENTERPRISE GRADE)
==================================================
Recipient:    ${recipient}
Channel:      ${channel.toUpperCase()}
OTP Code:     [ ${rawOtp} ]
Expires:      ${OTP_EXPIRATION_TIME_SECONDS} seconds
Hash Saved:   ${otpHash}
==================================================
`);

    return {
      session_id: sessionId,
      channel,
      expires_in: OTP_EXPIRATION_TIME_SECONDS,
    };
  }

  async verifyOtp(
    sessionId: string,
    phone: string,
    countryCode: string,
    otpCode: string,
  ): Promise<{ verification_token: string }> {
    const otp = await this.otpRepository.findById(sessionId);

    if (!otp) {
      throw new HttpException('Invalid OTP session', HttpStatus.BAD_REQUEST);
    }

    if (otp.phone !== phone || otp.countryCode !== countryCode) {
      throw new HttpException('OTP phone details mismatch', HttpStatus.BAD_REQUEST);
    }

    if (otp.isVerified) {
      throw new HttpException('OTP has already been verified', HttpStatus.BAD_REQUEST);
    }

    if (otp.expiresAt.getTime() < Date.now()) {
      throw new HttpException('OTP has expired', HttpStatus.BAD_REQUEST);
    }

    if (otp.attempts >= OTP_MAX_ATTEMPTS) {
      throw new HttpException('Max attempts reached. Please request a new OTP.', HttpStatus.BAD_REQUEST);
    }

    // Compare secure hash
    const isOtpValid = bcrypt.compareSync(otpCode, otp.otpHash);
    if (!isOtpValid) {
      const nextAttempts = otp.attempts + 1;
      await this.otpRepository.update(sessionId, { attempts: nextAttempts });
      
      throw new HttpException(
        `Incorrect OTP code. Attempts left: ${OTP_MAX_ATTEMPTS - nextAttempts}`,
        HttpStatus.BAD_REQUEST,
      );
    }

    // Mark as verified
    await this.otpRepository.update(sessionId, { isVerified: true });

    // Generate Verification Token signed by backend verification secret (expires in 15m)
    const verificationToken = jwt.sign(
      {
        phone,
        countryCode,
        verified: true,
      },
      this.verificationSecret,
      { expiresIn: '15m' },
    );

    return { verification_token: verificationToken };
  }

  getVerificationSecret(): string {
    return this.verificationSecret;
  }
}
