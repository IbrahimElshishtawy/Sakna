import { SessionService } from './session.service';
import { SessionRepository } from '../repositories/session.repository';
import { RedisService } from './redis.service';
import { UserSessionEntity } from '../entities/user-session.entity';
import { UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';

describe('SessionService (Enterprise RTR)', () => {
  let service: SessionService;
  let repository: jest.Mocked<SessionRepository>;
  let redisService: jest.Mocked<RedisService>;

  const refreshSecret = 'super_secure_refresh_secret_123';

  beforeEach(() => {
    repository = {
      save: jest.fn(),
      findById: jest.fn(),
      findActiveSession: jest.fn(),
      findActiveSessionsByUserId: jest.fn(),
      revokeSession: jest.fn(),
      revokeAllSessionsByUserId: jest.fn(),
      deleteExpiredSessions: jest.fn(),
    } as any;

    redisService = {
      setex: jest.fn(),
      exists: jest.fn(),
      get: jest.fn(),
      set: jest.fn(),
      del: jest.fn(),
    } as any;

    service = new SessionService(repository, redisService);
  });

  describe('rotateSession (RTR)', () => {
    it('should successfully rotate tokens and update session parameters', async () => {
      const mockToken = jwt.sign(
        { sub: 'usr_abc', session_id: 'sess_123' },
        refreshSecret
      );
      
      const mockHash = bcrypt.hashSync(mockToken, 10);

      const mockSession = new UserSessionEntity({
        id: 'sess_123',
        userId: 'usr_abc',
        deviceName: 'Mobile Device',
        ipAddress: '127.0.0.1',
        userAgent: 'Mozilla/5.0',
        refreshTokenHash: mockHash,
        isRevoked: false,
        lastActiveAt: new Date(),
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      });

      repository.findActiveSession.mockResolvedValue(mockSession);
      repository.save.mockImplementation(async (s) => s);

      const result = await service.rotateSession(mockToken, '127.0.0.1', 'Mozilla/5.0');

      expect(repository.findActiveSession).toHaveBeenCalledWith('sess_123');
      expect(repository.save).toHaveBeenCalled();
      expect(result.access_token).toBeDefined();
      expect(result.refresh_token).toBeDefined();
    });

    it('should detect a replay attack (reused token) and revoke all sessions for high security', async () => {
      const mockToken = jwt.sign(
        { sub: 'usr_abc', session_id: 'sess_123' },
        refreshSecret
      );

      // Save a DIFFERENT hash in DB (signifying token was already rotated/reused!)
      const anotherTokenHash = bcrypt.hashSync('another_token', 10);

      const mockSession = new UserSessionEntity({
        id: 'sess_123',
        userId: 'usr_abc',
        deviceName: 'Mobile Device',
        ipAddress: '127.0.0.1',
        userAgent: 'Mozilla/5.0',
        refreshTokenHash: anotherTokenHash, // Mismatch
        isRevoked: false,
        lastActiveAt: new Date(),
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
      });

      repository.findActiveSession.mockResolvedValue(mockSession);
      repository.findActiveSessionsByUserId.mockResolvedValue([mockSession]);

      await expect(
        service.rotateSession(mockToken, '127.0.0.1', 'Mozilla/5.0')
      ).rejects.toThrow(
        new UnauthorizedException('Breach detected. Refresh token reused. All sessions revoked.')
      );

      // Verify immediate Logout-All trigger
      expect(repository.revokeAllSessionsByUserId).toHaveBeenCalledWith('usr_abc');
    });
  });
});
