import { Injectable, UnauthorizedException } from '@nestjs/common';
import { SessionService } from '../services/session.service';

@Injectable()
export class JwtStrategy {
  constructor(private readonly sessionService: SessionService) {}

  async validate(token: string): Promise<any> {
    // Delegates verification to SessionService which queries Redis & PostgreSQL for blacklists & active session status
    const decoded = await this.sessionService.verifyAccessToken(token);
    return decoded;
  }
}
