import {
  Controller,
  Post,
  Get,
  Body,
  UseGuards,
  Req,
  UseInterceptors,
  UploadedFile,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AuthUseCase } from '../application/auth.usecase';
import { SendOtpDto } from '../application/dto/send-otp.dto';
import { VerifyOtpDto } from '../application/dto/verify-otp.dto';
import { RegisterDto } from '../application/dto/register.dto';
import { LoginDto } from '../application/dto/login.dto';
import { SocialLoginDto } from '../application/dto/social-login.dto';
import { CompleteProfileDto } from '../application/dto/complete-profile.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private readonly authUseCase: AuthUseCase) {}

  @Post('otp/send')
  @HttpCode(HttpStatus.OK)
  async sendOtp(@Body() dto: SendOtpDto) {
    const result = await this.authUseCase.sendOtp(dto);
    return {
      status: 'success',
      message: `OTP sent successfully via ${result.channel}`,
      data: result,
    };
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    const result = await this.authUseCase.verifyOtp(dto);
    return {
      status: 'success',
      message: 'Phone number verified successfully',
      data: result,
    };
  }

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  async register(@Body() dto: RegisterDto) {
    const result = await this.authUseCase.register(dto);
    return {
      status: 'success',
      message: 'User registered successfully',
      data: {
        user: {
          id: result.user.id,
          name: result.user.name,
          phone: `${result.user.countryCode}${result.user.phone}`,
          email: result.user.email,
          is_profile_complete: result.user.isProfileComplete,
        },
        tokens: result.tokens,
      },
    };
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() dto: LoginDto) {
    const result = await this.authUseCase.login(dto);
    return {
      status: 'success',
      message: 'Login successful',
      data: {
        user: {
          id: result.user.id,
          name: result.user.name,
          phone: result.user.phone ? `${result.user.countryCode}${result.user.phone}` : null,
          email: result.user.email,
          is_profile_complete: result.user.isProfileComplete,
        },
        tokens: result.tokens,
      },
    };
  }

  @Post('social')
  @HttpCode(HttpStatus.OK)
  async socialLogin(@Body() dto: SocialLoginDto) {
    const result = await this.authUseCase.socialLogin(dto);
    return {
      status: 'success',
      data: {
        user: {
          id: result.user.id,
          name: result.user.name,
          phone: result.user.phone ? `${result.user.countryCode}${result.user.phone}` : null,
          email: result.user.email,
          is_profile_complete: result.user.isProfileComplete,
        },
        tokens: result.tokens,
      },
    };
  }

  @Post('profile/complete')
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('avatar'))
  @HttpCode(HttpStatus.OK)
  async completeProfile(
    @Req() req: any,
    @Body() dto: CompleteProfileDto,
    @UploadedFile() file?: any,
  ) {
    const userId = req.user.userId;
    const offersEnabled = dto.offers_enabled === 'true';
    
    // Simulate image upload CDN generation
    const avatarUrl = file
      ? `https://cdn.sakna.com/avatars/${userId}_${Date.now()}_${file.originalname}`
      : undefined;

    const user = await this.authUseCase.completeProfile(
      userId,
      dto.gender,
      dto.dob,
      offersEnabled,
      avatarUrl,
      dto.phone,
      dto.country_code,
      dto.verification_token,
    );

    return {
      status: 'success',
      message: 'Profile completed successfully',
      data: {
        user: {
          id: user.id,
          name: user.name,
          phone: user.phone ? `${user.countryCode}${user.phone}` : null,
          email: user.email,
          gender: user.gender,
          dob: user.dob,
          avatar_url: user.avatarUrl,
          offers_enabled: user.offersEnabled,
          is_profile_complete: user.isProfileComplete,
        },
      },
    };
  }

  @Get('session')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async checkSession(@Req() req: any) {
    const userId = req.user.userId;
    const user = await this.authUseCase.checkSession(userId);
    return {
      status: 'success',
      data: {
        user: {
          id: user.id,
          name: user.name,
          phone: user.phone ? `${user.countryCode}${user.phone}` : null,
          email: user.email,
          gender: user.gender,
          avatar_url: user.avatarUrl,
          is_profile_complete: user.isProfileComplete,
        },
      },
    };
  }
}
