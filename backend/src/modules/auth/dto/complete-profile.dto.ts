import { IsNotEmpty, IsIn, Matches, IsBooleanString, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CompleteProfileDto {
  @ApiProperty({ example: 'MALE', enum: ['MALE', 'FEMALE'] })
  @IsNotEmpty()
  @IsIn(['MALE', 'FEMALE'])
  gender: 'MALE' | 'FEMALE';

  @ApiProperty({ example: '1995-08-20', description: 'Date of birth YYYY-MM-DD' })
  @IsNotEmpty()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'Date of birth must be in YYYY-MM-DD format' })
  dob: string;

  @ApiProperty({ example: 'true', description: 'Subscribe to newsletter / offers' })
  @IsNotEmpty()
  @IsBooleanString({ message: 'offers_enabled must be a boolean string ("true" or "false")' })
  offers_enabled: string;

  @ApiProperty({ example: '1002345678', description: 'Link phone number', required: false })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiProperty({ example: '+20', description: 'Dialing country code', required: false })
  @IsOptional()
  @IsString()
  country_code?: string;

  @ApiProperty({ example: 'v_tok_xxxx', description: 'Verification token from OTP verify', required: false })
  @IsOptional()
  @IsString()
  verification_token?: string;
}
