export class OtpEntity {
  sessionId: string;
  phone: string;
  countryCode: string;
  otpCode: string;
  expiresAt: Date;
  isVerified: boolean;
  channel: 'sms' | 'whatsapp';
  attempts: number;

  constructor(partial: Partial<OtpEntity>) {
    Object.assign(this, partial);
    this.isVerified = partial.isVerified ?? false;
    this.attempts = partial.attempts ?? 0;
  }

  isExpired(now: Date = new Date()): boolean {
    return now.getTime() > this.expiresAt.getTime();
  }

  isValid(code: string, now: Date = new Date()): boolean {
    return !this.isVerified && !this.isExpired(now) && this.otpCode === code && this.attempts < 3;
  }

  incrementAttempts(): void {
    this.attempts += 1;
  }
}
