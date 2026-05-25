import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { SessionService } from '../services/session.service';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly sessionService: SessionService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers['authorization'];

    if (!authHeader) {
      throw new UnauthorizedException('Authorization header is missing');
    }

    const parts = authHeader.split(' ');
    if (parts.length !== 2 || parts[0] !== 'Bearer') {
      throw new UnauthorizedException('Invalid authorization format. Use Bearer <token>');
    }

    const token = parts[1];
    
    // Verifies token signature, lifetime, Redis blacklist and active DB session
    const payload = await this.sessionService.verifyAccessToken(token);
    
    // Attach user information to request
    request.user = {
      userId: payload.sub,
      role: payload.role,
      sessionId: payload.session_id,
      tokenVersion: payload.token_version,
    };

    return true;
  }
}
