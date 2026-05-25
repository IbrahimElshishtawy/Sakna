import { IsNotEmpty, IsString, IsEmail, Matches, Equals, IsBoolean } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { STRONG_PASSWORD_REGEX, STRONG_PASSWORD_MESSAGE } from '../constants/auth.constants';

export class RegisterDto {
  @ApiProperty({ example: 'أحمد محمد علي', description: 'Full triple name' })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({ example: '1002345678', description: 'Phone number' })
  @IsNotEmpty()
  @IsString()
  phone: string;

  @ApiProperty({ example: '+20', description: 'Country dialing code' })
  @IsNotEmpty()
  @IsString()
  country_code: string;

  @ApiProperty({ example: 'ahmad@example.com', description: 'User Email Address' })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'Password123!', description: 'Strong password meeting criteria' })
  @IsNotEmpty()
  @Matches(STRONG_PASSWORD_REGEX, { message: STRONG_PASSWORD_MESSAGE })
  password: string;

  @ApiProperty({ example: 'v_tok_xxxxx', description: 'Verification token from OTP verify' })
  @IsNotEmpty()
  @IsString()
  verification_token: string;

  @ApiProperty({ example: true, description: 'User agreement' })
  @IsNotEmpty()
  @IsBoolean()
  @Equals(true, { message: 'You must agree to the terms and conditions' })
  agree_to_terms: boolean;
}
