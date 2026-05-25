import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { UserSessionEntity } from '../entities/user-session.entity';

@Injectable()
export class SessionRepository {
  constructor(
    @InjectRepository(UserSessionEntity)
    private readonly repo: Repository<UserSessionEntity>,
  ) {}

  async save(session: UserSessionEntity): Promise<UserSessionEntity> {
    return this.repo.save(session);
  }

  async findById(id: string): Promise<UserSessionEntity | null> {
    return this.repo.findOneBy({ id });
  }

  async findActiveSession(id: string): Promise<UserSessionEntity | null> {
    return this.repo.findOne({
      where: {
        id,
        isRevoked: false,
      },
    });
  }

  async findActiveSessionsByUserId(userId: string): Promise<UserSessionEntity[]> {
    return this.repo.find({
      where: {
        userId,
        isRevoked: false,
      },
      order: {
        lastActiveAt: 'DESC',
      },
    });
  }

  async revokeSession(id: string): Promise<void> {
    await this.repo.update(id, { isRevoked: true });
  }

  async revokeAllSessionsByUserId(userId: string): Promise<void> {
    await this.repo.update({ userId, isRevoked: false }, { isRevoked: true });
  }

  async deleteExpiredSessions(): Promise<void> {
    await this.repo.delete({
      expiresAt: LessThan(new Date()),
    });
  }
}
