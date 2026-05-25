import { IsNotEmpty, IsString, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { STRONG_PASSWORD_REGEX, STRONG_PASSWORD_MESSAGE } from '../constants/auth.constants';

export class ResetPasswordDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsIn...', description: 'Reset Password Token obtained from OTP verification' })
  @IsNotEmpty()
  @IsString()
  password_reset_token: string;

  @ApiProperty({ example: 'NewSecurePassword123!', description: 'Strong password meeting criteria' })
  @IsNotEmpty()
  @Matches(STRONG_PASSWORD_REGEX, { message: STRONG_PASSWORD_MESSAGE })
  new_password: string;
}
