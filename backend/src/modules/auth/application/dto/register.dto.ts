import { IsNotEmpty, IsString, IsEmail, MinLength, Equals, IsBoolean } from 'class-validator';

export class RegisterDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  phone: string;

  @IsNotEmpty()
  @IsString()
  country_code: string;

  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsNotEmpty()
  @MinLength(6, { message: 'Password must be at least 6 characters long' })
  password: string;

  @IsNotEmpty()
  @IsString()
  verification_token: string;

  @IsNotEmpty()
  @IsBoolean()
  @Equals(true, { message: 'You must agree to the terms and conditions' })
  agree_to_terms: boolean;
}
