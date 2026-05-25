import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class OtpDeliveryService {
  private readonly logger = new Logger('OtpDeliveryService');

  async sendOtp(phone: string, countryCode: string, code: string, channel: 'sms' | 'whatsapp'): Promise<boolean> {
    const recipient = `${countryCode}${phone}`;
    
    // In a real environment, you would integrate:
    // 1. Meta Cloud API (WhatsApp Business API)
    // 2. Twilio API (SMS / WhatsApp)
    // 3. UltraMsg or 4Whats
    // For local development and demonstration, we log it with a highly visible format:

    this.logger.log(`
==================================================
🔒 SAKNA OTP DELIVERY SIMULATOR
==================================================
Recipient: ${recipient}
Channel:   ${channel.toUpperCase()}
OTP Code:  [ ${code} ]
Expires:   120 seconds (2 minutes)
Message:   "Your Sakna verification code is ${code}. Please do not share it."
==================================================
`);

    return true;
  }
}
