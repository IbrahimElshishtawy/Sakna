import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('otp_sessions')
export class OtpSessionEntity {
  @PrimaryColumn({ type: 'varchar', length: 50 })
  id: string; // session_id

  @Column({ type: 'varchar', length: 30 })
  phone: string;

  @Column({ type: 'varchar', length: 10 })
  countryCode: string;

  @Column({ type: 'varchar', length: 255 })
  otpHash: string; // Store OTP Hash for maximum security

  @Column({ type: 'timestamp' })
  expiresAt: Date;

  @Column({ type: 'boolean', default: false })
  isVerified: boolean;

  @Column({ type: 'varchar', length: 20 })
  channel: 'sms' | 'whatsapp';

  @Column({ type: 'int', default: 0 })
  attempts: number;

  @Column({ type: 'timestamp', nullable: true })
  bannedUntil: Date | null;

  @CreateDateColumn()
  createdAt: Date;

  constructor(partial: Partial<OtpSessionEntity>) {
    Object.assign(this, partial);
    this.isVerified = partial?.isVerified ?? false;
    this.attempts = partial?.attempts ?? 0;
  }
}
