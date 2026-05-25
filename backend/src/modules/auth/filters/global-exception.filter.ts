import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger('GlobalExceptionFilter');

  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal Server Error';
    let errors: any = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const resContent: any = exception.getResponse();

      if (typeof resContent === 'object' && resContent !== null) {
        message = resContent.message || exception.message;
        // Parse validation errors arrays from class-validator
        if (Array.isArray(resContent.message)) {
          message = 'Validation failed';
          errors = resContent.message;
        }
      } else {
        message = exception.message;
      }
    } else {
      // Unhandled exceptions (log them securely)
      this.logger.error('Unhandled System Exception:', exception?.stack || exception);
      message = 'An unexpected error occurred. Please contact support.';
    }

    response.status(status).json({
      status: 'error',
      message,
      ...(errors && { errors }),
    });
  }
}
