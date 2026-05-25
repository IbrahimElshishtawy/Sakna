import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyOtpDto {
  @ApiProperty({ example: 'otp_sess_xxxx', description: 'Active OTP Session ID' })
  @IsNotEmpty()
  @IsString()
  session_id: string;

  @ApiProperty({ example: '1002345678', description: 'User phone number' })
  @IsNotEmpty()
  @IsString()
  phone: string;

  @ApiProperty({ example: '+20', description: 'Country code' })
  @IsNotEmpty()
  @IsString()
  country_code: string;

  @ApiProperty({ example: '123456', description: '6-digit OTP code received' })
  @IsNotEmpty()
  @IsString()
  otp_code: string;
}
