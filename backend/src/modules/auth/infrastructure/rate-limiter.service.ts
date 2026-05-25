import { Injectable, Inject, HttpException, HttpStatus } from '@nestjs/common';
import { IAuthRepository, AUTH_REPOSITORY } from '../domain/auth.repository.interface';

@Injectable()
export class RateLimiterService {
  constructor(
    @Inject(AUTH_REPOSITORY)
    private readonly authRepository: IAuthRepository,
  ) {}

  async checkRateLimit(phone: string, countryCode: string): Promise<void> {
    const tenMinutesMs = 10 * 60 * 1000;
    
    // Find all OTPs sent in the last 10 minutes
    const recentOtps = await this.authRepository.findLastOtpsByPhone(phone, countryCode, tenMinutesMs);
    
    // If the number of requests is >= 3, reject
    if (recentOtps.length >= 3) {
      throw new HttpException(
        {
          status: 'error',
          message: 'Too many OTP requests. Please try again after 10 minutes.',
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
  }
}
