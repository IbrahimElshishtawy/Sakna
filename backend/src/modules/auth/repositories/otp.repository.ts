import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import { OtpSessionEntity } from '../entities/otp-session.entity';

@Injectable()
export class OtpRepository {
  constructor(
    @InjectRepository(OtpSessionEntity)
    private readonly repo: Repository<OtpSessionEntity>,
  ) {}

  async save(otp: OtpSessionEntity): Promise<OtpSessionEntity> {
    return this.repo.save(otp);
  }

  async findById(id: string): Promise<OtpSessionEntity | null> {
    return this.repo.findOneBy({ id });
  }

  async update(id: string, data: Partial<OtpSessionEntity>): Promise<void> {
    await this.repo.update(id, data);
  }

  async findLastOtpsByPhone(
    phone: string,
    countryCode: string,
    timeWindowMs: number,
  ): Promise<OtpSessionEntity[]> {
    const threshold = new Date(Date.now() - timeWindowMs);
    return this.repo.find({
      where: {
        phone,
        countryCode,
        createdAt: MoreThan(threshold),
      },
    });
  }

  async findActiveBanByPhone(phone: string, countryCode: string): Promise<OtpSessionEntity | null> {
    const now = new Date();
    return this.repo.findOne({
      where: {
        phone,
        countryCode,
        bannedUntil: MoreThan(now),
      },
    });
  }
}
