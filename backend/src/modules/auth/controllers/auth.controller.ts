import {
  Controller,
  Post,
  Get,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  HttpCode,
  HttpStatus,
  Query,
  Req,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiResponse, ApiConsumes, ApiBearerAuth } from '@nestjs/swagger';
import { AuthService } from '../services/auth.service';
import { SessionService } from '../services/session.service';
import { SendOtpDto } from '../dto/send-otp.dto';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { RegisterDto } from '../dto/register.dto';
import { LoginDto } from '../dto/login.dto';
import { SocialLoginDto as CorrectSocialLoginDto } from '../dto/social-login.dto';
import { CompleteProfileDto } from '../dto/complete-profile.dto';
import { ForgotPasswordDto } from '../dto/forgot-password.dto';
import { VerifyPasswordOtpDto } from '../dto/verify-password-otp.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { RefreshTokenDto } from '../dto/refresh-token.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { FileSecurityInterceptor } from '../interceptors/file-security.interceptor';
import { AuditInterceptor } from '../interceptors/audit.interceptor';
import { GetUser } from '../decorators/get-user.decorator';
import { IpAgent } from '../decorators/ip-agent.decorator';
import type { IpAgentData } from '../decorators/ip-agent.decorator';

@ApiTags('Authentication & Sessions')
@Controller('api/v1/auth')
@UseInterceptors(AuditInterceptor)
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly sessionService: SessionService,
  ) {}

  @Post('otp/send')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Send an OTP code via SMS or WhatsApp' })
  @ApiResponse({ status: 200, description: 'OTP generated and sent' })
  async sendOtp(@Body() dto: SendOtpDto) {
    const result = await this.authService.forgotPassword(dto.phone, dto.country_code, dto.channel || 'sms');
    return {
      status: 'success',
      message: `OTP sent successfully via ${result.channel}`,
      data: result,
    };
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify the OTP code and retrieve phone verification token' })
  @ApiResponse({ status: 200, description: 'OTP verified successfully' })
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    const result = await this.authService.verifyPasswordOtp(
      dto.phone,
      dto.country_code,
      dto.otp_code,
      dto.session_id,
    );
    return {
      status: 'success',
      message: 'Phone number verified successfully',
      data: {
        verification_token: result.password_reset_token, // compatible with specs
      },
    };
  }

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Register a new user' })
  @ApiResponse({ status: 201, description: 'User registered and session created' })
  async register(
    @Body() dto: RegisterDto,
    @IpAgent() ipAgent: IpAgentData,
  ) {
    const result = await this.authService.register(
      dto,
      ipAgent.deviceName,
      ipAgent.ipAddress,
      ipAgent.userAgent,
    );
    return {
      status: 'success',
      message: 'User registered successfully',
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

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login using email or phone and password' })
  @ApiResponse({ status: 200, description: 'Login successful' })
  async login(
    @Body() dto: LoginDto,
    @IpAgent() ipAgent: IpAgentData,
  ) {
    const result = await this.authService.login(
      dto,
      ipAgent.deviceName,
      ipAgent.ipAddress,
      ipAgent.userAgent,
    );
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
  @ApiOperation({ summary: 'Login or signup via Google/Facebook SSO' })
  @ApiResponse({ status: 200, description: 'Social login successful' })
  async socialLogin(
    @Body() dto: CorrectSocialLoginDto,
    @IpAgent() ipAgent: IpAgentData,
  ) {
    const result = await this.authService.socialLogin(
      dto,
      ipAgent.deviceName,
      ipAgent.ipAddress,
      ipAgent.userAgent,
    );
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

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Rotate session tokens using long-lived Refresh Token (RTR)' })
  @ApiResponse({ status: 200, description: 'Tokens rotated successfully' })
  async refreshSession(
    @Body() dto: RefreshTokenDto,
    @IpAgent() ipAgent: IpAgentData,
  ) {
    const tokens = await this.sessionService.rotateSession(
      dto.refresh_token,
      ipAgent.ipAddress,
      ipAgent.userAgent,
    );
    return {
      status: 'success',
      data: tokens,
    };
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Logout from current device session' })
  @ApiResponse({ status: 200, description: 'Session revoked successfully' })
  async logout(@GetUser('sessionId') sessionId: string) {
    await this.sessionService.logout(sessionId);
    return {
      status: 'success',
      message: 'Logged out successfully',
    };
  }

  @Post('logout-all')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Logout from all device sessions' })
  @ApiResponse({ status: 200, description: 'All active sessions revoked' })
  async logoutAll(@GetUser('userId') userId: string) {
    await this.sessionService.logoutAll(userId);
    return {
      status: 'success',
      message: 'Logged out from all devices successfully',
    };
  }

  @Get('sessions')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get list of all active device sessions' })
  @ApiResponse({ status: 200, description: 'Active device list returned' })
  async getActiveSessions(
    @GetUser('userId') userId: string,
    @GetUser('sessionId') currentSessionId: string,
  ) {
    const list = await this.sessionService.getActiveSessions(userId, currentSessionId);
    return {
      status: 'success',
      data: list,
    };
  }

  @Post('profile/complete')
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('avatar'), FileSecurityInterceptor)
  @ApiConsumes('multipart/form-data')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Complete profile details and link verified phone number' })
  @ApiResponse({ status: 200, description: 'Profile completed successfully' })
  async completeProfile(
    @GetUser('userId') userId: string,
    @Body() dto: CompleteProfileDto,
    @UploadedFile() file?: any,
  ) {
    // Generate simulated avatar url
    const avatarUrl = file
      ? `https://cdn.sakna.com/avatars/${userId}_compressed.jpg`
      : undefined;

    const user = await this.authService.completeProfile(userId, dto, avatarUrl);

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
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify current access token and fetch profile details' })
  @ApiResponse({ status: 200, description: 'Session valid' })
  async checkSession(@GetUser('userId') userId: string) {
    const user = await this.authService.getUserById(userId);
    return {
      status: 'success',
      data: {
        user: {
          id: user?.id,
          name: user?.name,
          phone: user?.phone ? `${user.countryCode}${user.phone}` : null,
          email: user?.email,
          gender: user?.gender,
          avatar_url: user?.avatarUrl,
          is_profile_complete: user?.isProfileComplete,
        },
      },
    };
  }

  @Post('password/forgot')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Forgot password - Triggers OTP verification' })
  @ApiResponse({ status: 200, description: 'OTP sent successfully' })
  async forgotPassword(@Body() dto: ForgotPasswordDto) {
    const result = await this.authService.forgotPassword(dto.phone, dto.country_code, dto.channel || 'sms');
    return {
      status: 'success',
      message: `OTP sent successfully via ${result.channel}`,
      data: result,
    };
  }

  @Post('password/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify forgot password OTP to obtain Reset Token' })
  @ApiResponse({ status: 200, description: 'OTP confirmed, Reset token returned' })
  async verifyPasswordOtp(@Body() dto: VerifyPasswordOtpDto) {
    const result = await this.authService.verifyPasswordOtp(
      dto.phone,
      dto.country_code,
      dto.otp_code,
      dto.session_id,
    );
    return {
      status: 'success',
      data: result,
    };
  }

  @Post('password/reset')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reset account password' })
  @ApiResponse({ status: 200, description: 'Password reset successfully' })
  async resetPassword(@Body() dto: ResetPasswordDto) {
    await this.authService.resetPassword(dto);
    return {
      status: 'success',
      message: 'Password reset successfully. Please login with your new credentials.',
    };
  }

  @Get('email/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify user email address using verification token link' })
  @ApiResponse({ status: 200, description: 'Email address verified successfully' })
  async verifyEmail(@Query('token') token: string) {
    await this.authService.verifyEmail(token);
    return {
      status: 'success',
      message: 'Email address verified successfully',
    };
  }

  @Post('email/resend')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Resend email verification link' })
  @ApiResponse({ status: 200, description: 'Email verification link sent successfully' })
  async resendEmailVerification(@GetUser('userId') userId: string) {
    await this.authService.sendEmailVerification(userId);
    return {
      status: 'success',
      message: 'Email verification link sent successfully',
    };
  }
}
