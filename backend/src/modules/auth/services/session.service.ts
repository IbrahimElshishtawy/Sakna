import { Injectable, Inject, UnauthorizedException, Logger } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';
import { SessionRepository } from '../repositories/session.repository';
import { UserSessionEntity } from '../entities/user-session.entity';
import { RedisService } from './redis.service';
import {
  SESSION_REPOSITORY,
  JWT_ACCESS_EXPIRATION,
  JWT_REFRESH_EXPIRATION,
} from '../constants/auth.constants';

@Injectable()
export class SessionService {
  private readonly logger = new Logger('SessionService');
  private readonly accessSecret = process.env.JWT_ACCESS_SECRET || 'super_secure_access_secret_123';
  private readonly refreshSecret = process.env.JWT_REFRESH_SECRET || 'super_secure_refresh_secret_123';

  constructor(
    @Inject(SESSION_REPOSITORY)
    private readonly sessionRepository: SessionRepository,
    private readonly redisService: RedisService,
  ) {}

  async createSession(
    userId: string,
    role: string,
    deviceName: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ access_token: string; refresh_token: string }> {
    const sessionId = `sess_${Math.random().toString(36).substring(7)}`;
    
    // Refresh expires in 30 days
    const refreshExpiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

    // Sign Access & Refresh Tokens with payload matching requirements:
    // { sub: user_id, role, session_id, token_version }
    const accessToken = jwt.sign(
      { sub: userId, role, session_id: sessionId, token_version: 1 },
      this.accessSecret,
      { expiresIn: JWT_ACCESS_EXPIRATION },
    );

    const refreshToken = jwt.sign(
      { sub: userId, session_id: sessionId },
      this.refreshSecret,
      { expiresIn: JWT_REFRESH_EXPIRATION },
    );

    // Hash refresh token for DB storage
    const refreshTokenHash = bcrypt.hashSync(refreshToken, 10);

    const session = new UserSessionEntity({
      id: sessionId,
      userId,
      deviceName,
      ipAddress,
      userAgent,
      refreshTokenHash,
      isRevoked: false,
      lastActiveAt: new Date(),
      expiresAt: refreshExpiresAt,
    });

    await this.sessionRepository.save(session);
    return { access_token: accessToken, refresh_token: refreshToken };
  }

  async rotateSession(
    refreshToken: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ access_token: string; refresh_token: string }> {
    let decoded: any;
    try {
      decoded = jwt.verify(refreshToken, this.refreshSecret);
    } catch {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }

    const { sub: userId, session_id: sessionId } = decoded;

    // Fetch active session from DB
    const session = await this.sessionRepository.findActiveSession(sessionId);
    if (!session) {
      throw new UnauthorizedException('Session not found or already revoked');
    }

    // Replay attack prevention: verify incoming refresh token matches the hash in DB
    const isTokenValid = bcrypt.compareSync(refreshToken, session.refreshTokenHash);
    if (!isTokenValid) {
      // Replay Attack Detected! Someone tried to use a reused refresh token!
      this.logger.warn(`REPLAY ATTACK DETECTED! Revoking all sessions for user ${userId}`);
      await this.logoutAll(userId);
      throw new UnauthorizedException('Breach detected. Refresh token reused. All sessions revoked.');
    }

    // Generate new session tokens (rotation)
    const newRefreshExpiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

    const newAccessToken = jwt.sign(
      { sub: userId, role: 'USER', session_id: sessionId, token_version: 1 },
      this.accessSecret,
      { expiresIn: JWT_ACCESS_EXPIRATION },
    );

    const newRefreshToken = jwt.sign(
      { sub: userId, session_id: sessionId },
      this.refreshSecret,
      { expiresIn: JWT_REFRESH_EXPIRATION },
    );

    const newRefreshTokenHash = bcrypt.hashSync(newRefreshToken, 10);

    // Update session record
    session.refreshTokenHash = newRefreshTokenHash;
    session.ipAddress = ipAddress;
    session.userAgent = userAgent;
    session.lastActiveAt = new Date();
    session.expiresAt = newRefreshExpiresAt;

    await this.sessionRepository.save(session);

    return { access_token: newAccessToken, refresh_token: newRefreshToken };
  }

  async logout(sessionId: string): Promise<void> {
    await this.sessionRepository.revokeSession(sessionId);
    
    // Optional high-speed blacklist cache in Redis for 15 mins (Access Token expiry window)
    const blacklistKey = `blacklist:session:${sessionId}`;
    await this.redisService.setex(blacklistKey, 15 * 60, 'revoked');
  }

  async logoutAll(userId: string): Promise<void> {
    const activeSessions = await this.sessionRepository.findActiveSessionsByUserId(userId);
    
    // Revoke all in DB
    await this.sessionRepository.revokeAllSessionsByUserId(userId);

    // Blacklist all in Redis
    for (const session of activeSessions) {
      const blacklistKey = `blacklist:session:${session.id}`;
      await this.redisService.setex(blacklistKey, 15 * 60, 'revoked');
    }
  }

  async getActiveSessions(userId: string, currentSessionId: string): Promise<any[]> {
    const sessions = await this.sessionRepository.findActiveSessionsByUserId(userId);
    
    return sessions.map((s) => ({
      id: s.id,
      device_name: s.deviceName,
      ip_address: s.ipAddress,
      user_agent: s.userAgent,
      last_active_at: s.lastActiveAt,
      created_at: s.createdAt,
      is_current: s.id === currentSessionId,
    }));
  }

  async verifyAccessToken(token: string): Promise<any> {
    try {
      const decoded: any = jwt.verify(token, this.accessSecret);
      
      // Check Redis blacklist
      const isBlacklisted = await this.redisService.exists(`blacklist:session:${decoded.session_id}`);
      if (isBlacklisted) {
        throw new UnauthorizedException('Session has been logged out');
      }

      // Check PostgreSQL active session
      const session = await this.sessionRepository.findActiveSession(decoded.session_id);
      if (!session) {
        throw new UnauthorizedException('Session has been revoked');
      }

      return decoded;
    } catch {
      throw new UnauthorizedException('Invalid or expired access token');
    }
  }
}
