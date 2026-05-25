import { IsNotEmpty, IsString, IsOptional, IsIn } from 'class-validator';

export class SendOtpDto {
  @IsNotEmpty()
  @IsString()
  phone: string;

  @IsNotEmpty()
  @IsString()
  country_code: string;

  @IsOptional()
  @IsIn(['sms', 'whatsapp'])
  channel?: 'sms' | 'whatsapp';
}
