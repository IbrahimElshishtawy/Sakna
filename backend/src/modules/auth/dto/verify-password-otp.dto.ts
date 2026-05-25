import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyPasswordOtpDto {
  @ApiProperty({ example: '1002345678', description: 'User phone number' })
  @IsNotEmpty()
  @IsString()
  phone: string;

  @ApiProperty({ example: '+20', description: 'Country dialing code' })
  @IsNotEmpty()
  @IsString()
  country_code: string;

  @ApiProperty({ example: '123456', description: '6-digit OTP code' })
  @IsNotEmpty()
  @IsString()
  otp_code: string;

  @ApiProperty({ example: 'otp_sess_xxxxx', description: 'Active OTP session ID' })
  @IsNotEmpty()
  @IsString()
  session_id: string;
}
