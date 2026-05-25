import { IsNotEmpty, IsString, IsEmail, IsOptional, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SocialLoginDto {
  @ApiProperty({ example: 'google', enum: ['google', 'facebook'] })
  @IsNotEmpty()
  @IsIn(['google', 'facebook'])
  provider: 'google' | 'facebook';

  @ApiProperty({ example: 'social_access_token_xyz', description: 'SSO Token from Google or Facebook Client SDK' })
  @IsNotEmpty()
  @IsString()
  social_token: string;

  @ApiProperty({ example: 'user@gmail.com', description: 'Federated User Email' })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'Ahmad Mohammad', description: 'Federated User Full Name' })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({ example: 'https://lh3.googleusercontent.com/avatar', description: 'SSO User avatar image link', required: false })
  @IsOptional()
  @IsString()
  avatar_url?: string;
}
