import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from '../entities/user.entity';

@Injectable()
export class UserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly repo: Repository<UserEntity>,
  ) {}

  async findById(id: string): Promise<UserEntity | null> {
    return this.repo.findOneBy({ id });
  }

  async findByEmail(email: string): Promise<UserEntity | null> {
    return this.repo.findOneBy({ email });
  }

  async findByPhone(phone: string, countryCode: string): Promise<UserEntity | null> {
    return this.repo.findOneBy({ phone, countryCode });
  }

  async findByEmailOrPhone(
    email: string,
    phone: string,
    countryCode: string,
  ): Promise<UserEntity | null> {
    const query = this.repo.createQueryBuilder('user');
    if (email) {
      query.where('user.email = :email', { email });
    }
    if (phone && countryCode) {
      if (email) {
        query.orWhere('(user.phone = :phone AND user.countryCode = :countryCode)', {
          phone,
          countryCode,
        });
      } else {
        query.where('user.phone = :phone AND user.countryCode = :countryCode', {
          phone,
          countryCode,
        });
      }
    }
    return query.getOne();
  }

  async save(user: UserEntity): Promise<UserEntity> {
    return this.repo.save(user);
  }

  async update(id: string, data: Partial<UserEntity>): Promise<void> {
    await this.repo.update(id, data);
  }
}
