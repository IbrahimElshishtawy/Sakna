import { Injectable, UnauthorizedException } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class JwtService {
  private readonly accessSecret = process.env.JWT_ACCESS_SECRET || 'super_secure_access_secret_123';
  private readonly refreshSecret = process.env.JWT_REFRESH_SECRET || 'super_secure_refresh_secret_123';

  generateAccessToken(payload: { userId: string; email: string }): string {
    return jwt.sign(payload, this.accessSecret, { expiresIn: '15m' });
  }

  generateRefreshToken(payload: { userId: string }): string {
    return jwt.sign(payload, this.refreshSecret, { expiresIn: '30d' });
  }

  verifyAccessToken(token: string): { userId: string; email: string } {
    try {
      return jwt.verify(token, this.accessSecret) as { userId: string; email: string };
    } catch {
      throw new UnauthorizedException('Invalid or expired access token');
    }
  }

  verifyRefreshToken(token: string): { userId: string } {
    try {
      return jwt.verify(token, this.refreshSecret) as { userId: string };
    } catch {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }
}
