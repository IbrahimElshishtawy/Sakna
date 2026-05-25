import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './controllers/auth.controller';
import { AuthService } from './services/auth.service';
import { SessionService } from './services/session.service';
import { OtpService } from './services/otp.service';
import { RedisService } from './services/redis.service';
import { SocialAuthService as CorrectSocialAuthService } from './services/social-auth.service';
import { UserRepository } from './repositories/user.repository';
import { SessionRepository } from './repositories/session.repository';
import { OtpRepository } from './repositories/otp.repository';
import { UserEntity } from './entities/user.entity';
import { UserSessionEntity } from './entities/user-session.entity';
import { OtpSessionEntity } from './entities/otp-session.entity';
import { AuditLogEntity } from './entities/audit-log.entity';
import {
  AUTH_REPOSITORY,
  SESSION_REPOSITORY,
  OTP_REPOSITORY,
} from './constants/auth.constants';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserEntity,
      UserSessionEntity,
      OtpSessionEntity,
      AuditLogEntity,
    ]),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    SessionService,
    OtpService,
    RedisService,
    CorrectSocialAuthService,
    UserRepository,
    SessionRepository,
    OtpRepository,
    {
      provide: AUTH_REPOSITORY,
      useClass: UserRepository,
    },
    {
      provide: SESSION_REPOSITORY,
      useClass: SessionRepository,
    },
    {
      provide: OTP_REPOSITORY,
      useClass: OtpRepository,
    },
  ],
  exports: [
    AuthService,
    SessionService,
    OtpService,
    AUTH_REPOSITORY,
    SESSION_REPOSITORY,
    OTP_REPOSITORY,
  ],
})
export class AuthModule {}
