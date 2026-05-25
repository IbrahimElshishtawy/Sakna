import { IsNotEmpty, IsString, IsEmail, IsOptional, IsIn } from 'class-validator';

export class SocialLoginDto {
  @IsNotEmpty()
  @IsIn(['google', 'facebook'])
  provider: 'google' | 'facebook';

  @IsNotEmpty()
  @IsString()
  social_token: string;

  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsNotEmpty()
  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  avatar_url?: string;
}
