import { Injectable } from '@nestjs/common';
import { IAuthRepository } from '../domain/auth.repository.interface';
import { UserEntity } from '../domain/user.entity';
import { OtpEntity } from '../domain/otp.entity';

@Injectable()
export class AuthRepository implements IAuthRepository {
  private users: UserEntity[] = [];
  private otps: OtpEntity[] = [];

  async findUserByEmailOrPhone(email: string, phone: string, countryCode: string): Promise<UserEntity | null> {
    const user = this.users.find(
      (u) =>
        u.email === email || (u.phone === phone && u.countryCode === countryCode),
    );
    return user ? new UserEntity(user) : null;
  }

  async findUserById(id: string): Promise<UserEntity | null> {
    const user = this.users.find((u) => u.id === id);
    return user ? new UserEntity(user) : null;
  }

  async findUserByEmail(email: string): Promise<UserEntity | null> {
    const user = this.users.find((u) => u.email === email);
    return user ? new UserEntity(user) : null;
  }

  async createUser(user: UserEntity): Promise<UserEntity> {
    user.id = user.id || `usr_${Math.random().toString(36).substring(7)}`;
    this.users.push(user);
    return new UserEntity(user);
  }

  async updateUser(id: string, updateData: Partial<UserEntity>): Promise<UserEntity> {
    const index = this.users.findIndex((u) => u.id === id);
    if (index === -1) {
      throw new Error('User not found');
    }
    const updated = Object.assign(this.users[index], updateData);
    return new UserEntity(updated);
  }

  async saveOtp(otp: OtpEntity): Promise<OtpEntity> {
    otp.sessionId = otp.sessionId || `otp_sess_${Math.random().toString(36).substring(7)}`;
    this.otps.push(otp);
    return new OtpEntity(otp);
  }

  async findOtpBySession(sessionId: string): Promise<OtpEntity | null> {
    const otp = this.otps.find((o) => o.sessionId === sessionId);
    return otp ? new OtpEntity(otp) : null;
  }

  async updateOtp(sessionId: string, updateData: Partial<OtpEntity>): Promise<OtpEntity> {
    const index = this.otps.findIndex((o) => o.sessionId === sessionId);
    if (index === -1) {
      throw new Error('OTP session not found');
    }
    const updated = Object.assign(this.otps[index], updateData);
    return new OtpEntity(updated);
  }

  async findLastOtpsByPhone(phone: string, countryCode: string, timeWindowMs: number): Promise<OtpEntity[]> {
    const threshold = new Date(Date.now() - timeWindowMs);
    return this.otps
      .filter((o) => o.phone === phone && o.countryCode === countryCode && o.expiresAt > threshold)
      .map((o) => new OtpEntity(o));
  }
}
