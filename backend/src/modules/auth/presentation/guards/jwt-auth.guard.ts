import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '../../infrastructure/jwt.service';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
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
    try {
      const decoded = this.jwtService.verifyAccessToken(token);
      request.user = decoded; // Bind the decoded token payload to the request
      return true;
    } catch {
      throw new UnauthorizedException('Invalid or expired access token');
    }
  }
}
