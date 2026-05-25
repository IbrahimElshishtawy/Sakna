import { IsNotEmpty, IsString, IsOptional, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class ForgotPasswordDto {
  @ApiProperty({ example: '1002345678', description: 'User phone number' })
  @IsNotEmpty()
  @IsString()
  phone: string;

  @ApiProperty({ example: '+20', description: 'Country dialing code' })
  @IsNotEmpty()
  @IsString()
  country_code: string;

  @ApiProperty({ example: 'whatsapp', enum: ['sms', 'whatsapp'], required: false })
  @IsOptional()
  @IsIn(['sms', 'whatsapp'])
  channel?: 'sms' | 'whatsapp';
}
