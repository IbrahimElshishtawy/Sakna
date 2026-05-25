import { IsNotEmpty, IsIn, Matches, IsBooleanString, IsOptional, IsString } from 'class-validator';

export class CompleteProfileDto {
  @IsNotEmpty()
  @IsIn(['MALE', 'FEMALE'])
  gender: 'MALE' | 'FEMALE';

  @IsNotEmpty()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'Date of birth must be in YYYY-MM-DD format' })
  dob: string;

  @IsNotEmpty()
  @IsBooleanString({ message: 'offers_enabled must be a boolean string ("true" or "false")' })
  offers_enabled: string; // Since multipart/form-data sends everything as strings

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  country_code?: string;

  @IsOptional()
  @IsString()
  verification_token?: string;
}
