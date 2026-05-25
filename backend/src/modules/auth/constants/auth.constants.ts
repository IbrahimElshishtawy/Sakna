export const AUTH_REPOSITORY = 'AUTH_REPOSITORY';
export const SESSION_REPOSITORY = 'SESSION_REPOSITORY';
export const OTP_REPOSITORY = 'OTP_REPOSITORY';

export const JWT_ACCESS_EXPIRATION = '15m';
export const JWT_REFRESH_EXPIRATION = '30d';

export const OTP_EXPIRATION_TIME_SECONDS = 120; // 2 minutes
export const OTP_MAX_ATTEMPTS = 3;
export const OTP_BAN_DURATION_MINUTES = 10; // Temp ban for 10 minutes if limits exceeded
export const OTP_TIME_WINDOW_MINUTES = 10; // Rate limit window: 3 requests per 10 minutes
export const OTP_MAX_REQUESTS_IN_WINDOW = 3;

export const STRONG_PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;
export const STRONG_PASSWORD_MESSAGE =
  'Password must contain at least one uppercase letter, one lowercase letter, one number, one special character, and be at least 8 characters long';
