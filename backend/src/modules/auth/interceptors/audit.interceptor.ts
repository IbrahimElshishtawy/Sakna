import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLogEntity } from '../entities/audit-log.entity';

@Injectable()
export class AuditInterceptor implements NestInterceptor {
  constructor(
    @InjectRepository(AuditLogEntity)
    private readonly auditLogRepository: Repository<AuditLogEntity>,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url, headers } = request;
    const ipAddress = request.ip || request.headers['x-forwarded-for'] || '127.0.0.1';
    const userAgent = headers['user-agent'] || 'unknown';

    return next.handle().pipe(
      tap({
        next: async (response) => {
          // Log only successful mutation requests
          if (method !== 'GET') {
            await this.createAuditLog(request, ipAddress, userAgent, 'SUCCESS', response);
          }
        },
        error: async (err) => {
          await this.createAuditLog(request, ipAddress, userAgent, `FAILED: ${err.message}`);
        },
      }),
    );
  }

  private async createAuditLog(
    request: any,
    ipAddress: string,
    userAgent: string,
    status: string,
    response?: any,
  ): Promise<void> {
    try {
      const url = request.url;
      let action = 'UNKNOWN_ACTION';

      if (url.includes('/otp/send')) action = 'OTP_REQUEST';
      else if (url.includes('/otp/verify')) action = 'OTP_VERIFICATION';
      else if (url.includes('/register')) action = 'USER_REGISTRATION';
      else if (url.includes('/login')) action = 'USER_LOGIN';
      else if (url.includes('/social')) action = 'SOCIAL_LOGIN';
      else if (url.includes('/logout-all')) action = 'LOGOUT_ALL_DEVICES';
      else if (url.includes('/logout')) action = 'USER_LOGOUT';
      else if (url.includes('/profile/complete')) action = 'PROFILE_CHANGE';
      else if (url.includes('/password/forgot')) action = 'PASSWORD_FORGOT_REQUEST';
      else if (url.includes('/password/reset')) action = 'PASSWORD_RESET';
      else if (url.includes('/email/verify')) action = 'EMAIL_VERIFICATION';

      const userId = request.user?.userId || response?.data?.user?.id || null;

      // Filter sensitive details out of metadata
      const cleanBody = { ...request.body };
      delete cleanBody.password;
      delete cleanBody.new_password;
      delete cleanBody.social_token;
      delete cleanBody.otp_code;

      const metadata = JSON.stringify({
        status,
        body: cleanBody,
        url,
      });

      const auditLog = new AuditLogEntity({
        id: `audit_${Math.random().toString(36).substring(7)}`,
        userId,
        action,
        ipAddress,
        userAgent,
        metadata,
      });

      await this.auditLogRepository.save(auditLog);
    } catch {
      // Fail silently to prevent audit errors from blocking core business flows
    }
  }
}
