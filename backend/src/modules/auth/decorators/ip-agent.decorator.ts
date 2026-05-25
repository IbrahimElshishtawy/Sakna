import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export interface IpAgentData {
  ipAddress: string;
  userAgent: string;
  deviceName: string;
}

export const IpAgent = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): IpAgentData => {
    const request = ctx.switchToHttp().getRequest();
    const { headers } = request;
    
    const ipAddress = request.ip || headers['x-forwarded-for'] || '127.0.0.1';
    const userAgent = headers['user-agent'] || 'unknown';

    // Geolocation / Geodevice extract: parse device name from User-Agent securely
    let deviceName = 'Web Browser';
    if (/mobile/i.test(userAgent)) {
      deviceName = 'Mobile Device';
      if (/iphone|ipad/i.test(userAgent)) deviceName = 'iOS Device';
      else if (/android/i.test(userAgent)) deviceName = 'Android Device';
    } else if (/tablet/i.test(userAgent)) {
      deviceName = 'Tablet';
    } else if (/postman/i.test(userAgent)) {
      deviceName = 'Postman Client';
    }

    return {
      ipAddress,
      userAgent,
      deviceName,
    };
  },
);
