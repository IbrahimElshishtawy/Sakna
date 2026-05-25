import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RefreshTokenDto {
  @ApiProperty({ example: 'r_tok_xxxx', description: 'Long-lived JWT Refresh Token' })
  @IsNotEmpty()
  @IsString()
  refresh_token: string;
}
