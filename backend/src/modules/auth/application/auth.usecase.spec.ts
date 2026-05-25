import { AuthUseCase } from './auth.usecase';
import { IAuthRepository } from '../domain/auth.repository.interface';
import { UserEntity } from '../domain/user.entity';
import { OtpEntity } from '../domain/otp.entity';
import { OtpDeliveryService } from '../infrastructure/otp-delivery.service';
import { RateLimiterService } from '../infrastructure/rate-limiter.service';
import { JwtService } from '../infrastructure/jwt.service';
import { HttpException, HttpStatus } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';

describe('AuthUseCase', () => {
  let useCase: AuthUseCase;
  let repository: jest.Mocked<IAuthRepository>;
  let otpDeliveryService: jest.Mocked<OtpDeliveryService>;
  let rateLimiterService: jest.Mocked<RateLimiterService>;
  let jwtService: jest.Mocked<JwtService>;

  const verificationSecret = 'super_secure_verification_secret_123';

  beforeEach(() => {
    repository = {
      findUserByEmailOrPhone: jest.fn(),
      findUserById: jest.fn(),
      findUserByEmail: jest.fn(),
      createUser: jest.fn(),
      updateUser: jest.fn(),
      saveOtp: jest.fn(),
      findOtpBySession: jest.fn(),
      updateOtp: jest.fn(),
      findLastOtpsByPhone: jest.fn(),
    } as any;

    otpDeliveryService = {
      sendOtp: jest.fn().mockResolvedValue(true),
    } as any;

    rateLimiterService = {
      checkRateLimit: jest.fn(),
    } as any;

    jwtService = {
      generateAccessToken: jest.fn().mockReturnValue('mock_access_token'),
      generateRefreshToken: jest.fn().mockReturnValue('mock_refresh_token'),
      verifyAccessToken: jest.fn(),
      verifyRefreshToken: jest.fn(),
    } as any;

    useCase = new AuthUseCase(
      repository,
      otpDeliveryService,
      rateLimiterService,
      jwtService,
    );
  });

  describe('sendOtp', () => {
    it('should successfully send an OTP and return details', async () => {
      const dto = { phone: '1002345678', country_code: '+20', channel: 'whatsapp' as const };
      
      const mockSavedOtp = new OtpEntity({
        sessionId: 'otp_sess_123',
        phone: dto.phone,
        countryCode: dto.country_code,
        otpCode: '123456',
        expiresAt: new Date(Date.now() + 120 * 1000),
        channel: 'whatsapp',
      });
      repository.saveOtp.mockResolvedValue(mockSavedOtp);

      const result = await useCase.sendOtp(dto);

      expect(rateLimiterService.checkRateLimit).toHaveBeenCalledWith(dto.phone, dto.country_code);
      expect(repository.saveOtp).toHaveBeenCalled();
      expect(otpDeliveryService.sendOtp).toHaveBeenCalled();
      expect(result.session_id).toBe('otp_sess_123');
      expect(result.channel).toBe('whatsapp');
      expect(result.expires_in).toBe(120);
    });

    it('should throw an error if rate limit is exceeded', async () => {
      const dto = { phone: '1002345678', country_code: '+20' };
      rateLimiterService.checkRateLimit.mockRejectedValue(
        new HttpException('Too many OTP requests', HttpStatus.TOO_MANY_REQUESTS)
      );

      await expect(useCase.sendOtp(dto)).rejects.toThrow(
        new HttpException('Too many OTP requests', HttpStatus.TOO_MANY_REQUESTS)
      );
    });
  });

  describe('verifyOtp', () => {
    it('should successfully verify a correct OTP and return verification token', async () => {
      const dto = {
        session_id: 'otp_sess_123',
        phone: '1002345678',
        country_code: '+20',
        otp_code: '123456',
      };

      const mockOtp = new OtpEntity({
        sessionId: 'otp_sess_123',
        phone: dto.phone,
        countryCode: dto.country_code,
        otpCode: dto.otp_code,
        expiresAt: new Date(Date.now() + 60 * 1000), // active
        isVerified: false,
        attempts: 0,
        channel: 'sms',
      });

      repository.findOtpBySession.mockResolvedValue(mockOtp);

      const result = await useCase.verifyOtp(dto);

      expect(repository.findOtpBySession).toHaveBeenCalledWith(dto.session_id);
      expect(repository.updateOtp).toHaveBeenCalledWith(dto.session_id, { isVerified: true });
      expect(result.verification_token).toBeDefined();
    });

    it('should throw error and increment attempts on wrong code', async () => {
      const dto = {
        session_id: 'otp_sess_123',
        phone: '1002345678',
        country_code: '+20',
        otp_code: '000000', // incorrect code
      };

      const mockOtp = new OtpEntity({
        sessionId: 'otp_sess_123',
        phone: dto.phone,
        countryCode: dto.country_code,
        otpCode: '123456',
        expiresAt: new Date(Date.now() + 60 * 1000),
        isVerified: false,
        attempts: 0,
        channel: 'sms',
      });

      repository.findOtpBySession.mockResolvedValue(mockOtp);

      await expect(useCase.verifyOtp(dto)).rejects.toThrow(HttpException);
      expect(repository.updateOtp).toHaveBeenCalledWith(dto.session_id, { attempts: 1 });
    });

    it('should throw error on expired OTP code', async () => {
      const dto = {
        session_id: 'otp_sess_123',
        phone: '1002345678',
        country_code: '+20',
        otp_code: '123456',
      };

      const mockOtp = new OtpEntity({
        sessionId: 'otp_sess_123',
        phone: dto.phone,
        countryCode: dto.country_code,
        otpCode: '123456',
        expiresAt: new Date(Date.now() - 1000), // expired
        isVerified: false,
        attempts: 0,
        channel: 'sms',
      });

      repository.findOtpBySession.mockResolvedValue(mockOtp);

      await expect(useCase.verifyOtp(dto)).rejects.toThrow('OTP code has expired (2 minutes limit)');
    });
  });

  describe('register', () => {
    it('should throw error if name does not have 3 parts', async () => {
      // Create valid verification token
      const validToken = jwt.sign(
        { phone: '1002345678', countryCode: '+20', verified: true },
        verificationSecret
      );

      const dto = {
        name: 'أحمد محمد', // only 2 words
        phone: '1002345678',
        country_code: '+20',
        email: 'ahmad@example.com',
        password: 'Password123',
        verification_token: validToken,
        agree_to_terms: true,
      };

      await expect(useCase.register(dto)).rejects.toThrow('Full name must contain at least three parts (اسم ثلاثي على الأقل)');
    });

    it('should successfully register a valid user request', async () => {
      const validToken = jwt.sign(
        { phone: '1223070571', countryCode: '+20', verified: true },
        verificationSecret
      );

      const dto = {
        name: 'أحمد محمد علي', // triple name
        phone: '1223070571',
        country_code: '+20',
        email: 'ahmad@example.com',
        password: 'Password123',
        verification_token: validToken,
        agree_to_terms: true,
      };

      repository.findUserByEmailOrPhone.mockResolvedValue(null);
      repository.createUser.mockImplementation(async (u) => u);

      const result = await useCase.register(dto);

      expect(repository.createUser).toHaveBeenCalled();
      expect(result.tokens.access_token).toBe('mock_access_token');
      expect(result.tokens.refresh_token).toBe('mock_refresh_token');
    });
  });

  describe('login', () => {
    it('should throw error for non-existent users', async () => {
      const dto = { login_field: 'unknown@example.com', password: 'Password123' };
      repository.findUserByEmail.mockResolvedValue(null);

      await expect(useCase.login(dto)).rejects.toThrow('Invalid login credentials');
    });
  });
});
