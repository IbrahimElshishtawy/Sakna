import { Module } from '@nestjs/common';
import { AuthController } from './presentation/auth.controller';
import { AuthUseCase } from './application/auth.usecase';
import { AuthRepository } from './infrastructure/auth.repository';
import { AUTH_REPOSITORY } from './domain/auth.repository.interface';
import { JwtService } from './infrastructure/jwt.service';
import { OtpDeliveryService } from './infrastructure/otp-delivery.service';
import { RateLimiterService } from './infrastructure/rate-limiter.service';

@Module({
  controllers: [AuthController],
  providers: [
    AuthUseCase,
    JwtService,
    OtpDeliveryService,
    RateLimiterService,
    {
      provide: AUTH_REPOSITORY,
      useClass: AuthRepository,
    },
  ],
  exports: [JwtService, AUTH_REPOSITORY],
})
export class AuthModule {}
