import { UserEntity } from './user.entity';
import { OtpEntity } from './otp.entity';

export const AUTH_REPOSITORY = 'AUTH_REPOSITORY';

export interface IAuthRepository {
  findUserByEmailOrPhone(email: string, phone: string, countryCode: string): Promise<UserEntity | null>;
  findUserById(id: string): Promise<UserEntity | null>;
  findUserByEmail(email: string): Promise<UserEntity | null>;
  createUser(user: UserEntity): Promise<UserEntity>;
  updateUser(id: string, user: Partial<UserEntity>): Promise<UserEntity>;
  
  saveOtp(otp: OtpEntity): Promise<OtpEntity>;
  findOtpBySession(sessionId: string): Promise<OtpEntity | null>;
  updateOtp(sessionId: string, otp: Partial<OtpEntity>): Promise<OtpEntity>;
  findLastOtpsByPhone(phone: string, countryCode: string, timeWindowMs: number): Promise<OtpEntity[]>;
}
