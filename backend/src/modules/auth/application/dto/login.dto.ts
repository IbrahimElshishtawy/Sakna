import { IsNotEmpty, IsString } from 'class-validator';

export class LoginDto {
  @IsNotEmpty()
  @IsString()
  login_field: string; // Email or phone number

  @IsNotEmpty()
  @IsString()
  password: string;
}
