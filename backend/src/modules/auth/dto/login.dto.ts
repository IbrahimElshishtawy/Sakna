import { IsNotEmpty, IsString, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ example: 'ahmad@example.com', description: 'Email address or Phone number' })
  @IsNotEmpty()
  @IsString()
  login_field: string;

  @ApiProperty({ example: '+20', description: 'Country dialing code (required only if login_field is phone)', required: false })
  @IsOptional()
  @IsString()
  country_code?: string;

  @ApiProperty({ example: 'Password123!', description: 'User account password' })
  @IsNotEmpty()
  @IsString()
  password: string;
}
