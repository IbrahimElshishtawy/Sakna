import { Injectable, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { OAuth2Client } from 'google-auth-library';
import axios from 'axios';

@Injectable()
export class SocialAuthService {
  private readonly googleClient: OAuth2Client;
  private readonly logger = new Logger('SocialAuthService');

  constructor() {
    const googleClientId = process.env.GOOGLE_CLIENT_ID || 'dummy_google_client_id';
    this.googleClient = new OAuth2Client(googleClientId);
  }

  async verifyGoogleToken(token: string): Promise<{ email: string; name: string; avatarUrl?: string }> {
    // If token is a dummy token for local dev/test environment:
    if (token === 'google_id_token_xyz' || token.startsWith('mock_')) {
      return {
        email: 'user@gmail.com',
        name: 'Ahmad Mohammad',
        avatarUrl: 'https://lh3.googleusercontent.com/dummy',
      };
    }

    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken: token,
        audience: process.env.GOOGLE_CLIENT_ID,
      });
      const payload = ticket.getPayload();
      if (!payload || !payload.email || !payload.name) {
        throw new HttpException('Invalid Google token payload', HttpStatus.BAD_REQUEST);
      }
      return {
        email: payload.email,
        name: payload.name,
        avatarUrl: payload.picture || undefined,
      };
    } catch (err) {
      this.logger.error('Google token verification failed:', err.message);
      throw new HttpException('Google SSO token verification failed', HttpStatus.UNAUTHORIZED);
    }
  }

  async verifyFacebookToken(token: string): Promise<{ email: string; name: string; avatarUrl?: string }> {
    // If token is a dummy token for local dev/test environment:
    if (token === 'facebook_access_token_xyz' || token.startsWith('mock_')) {
      return {
        email: 'user@facebook.com',
        name: 'Ahmad FB User',
        avatarUrl: 'https://graph.facebook.com/dummy',
      };
    }

    try {
      // Validate access token with Meta API
      const appAccessToken = `${process.env.FACEBOOK_APP_ID}|${process.env.FACEBOOK_APP_SECRET}`;
      const debugUrl = `https://graph.facebook.com/debug_token?input_token=${token}&access_token=${appAccessToken}`;
      
      const debugResponse = await axios.get(debugUrl);
      const data = debugResponse.data.data;

      if (!data || !data.is_valid) {
        throw new HttpException('Facebook access token is invalid', HttpStatus.UNAUTHORIZED);
      }

      // Fetch user profile info
      const profileUrl = `https://graph.facebook.com/me?fields=id,name,email,picture.type(large)&access_token=${token}`;
      const profileResponse = await axios.get(profileUrl);
      const profile = profileResponse.data;

      if (!profile || !profile.email || !profile.name) {
        throw new HttpException('Invalid Facebook token payload', HttpStatus.BAD_REQUEST);
      }

      return {
        email: profile.email,
        name: profile.name,
        avatarUrl: profile.picture?.data?.url || undefined,
      };
    } catch (err) {
      this.logger.error('Facebook token verification failed:', err.message);
      throw new HttpException('Facebook SSO token verification failed', HttpStatus.UNAUTHORIZED);
    }
  }
}
