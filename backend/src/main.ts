import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
import * as compression from 'compression';
import { GlobalExceptionFilter } from './modules/auth/filters/global-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // 1. Enable Helmet for Secure Headers & CSP (Content Security Policy) Protection
  app.use(
    helmet({
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          scriptSrc: ["'self'", "'unsafe-inline'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          imgSrc: ["'self'", 'data:', 'https://cdn.sakna.com'],
        },
      },
      referrerPolicy: { policy: 'same-origin' },
    }),
  );

  // 2. Enable GZIP compression to optimize payload delivery sizes
  app.use(compression());

  // 3. Strict CORS (Cross-Origin Resource Sharing) Configuration
  app.enableCors({
    origin: process.env.ALLOWED_ORIGINS
      ? process.env.ALLOWED_ORIGINS.split(',')
      : ['http://localhost:3000', 'http://localhost:3001'],
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
    allowedHeaders: 'Content-Type, Accept, Authorization',
  });

  // 4. Secure Cookie headers, SameSite protection & Global Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // Automatically strip non-whitelist request fields
      transform: true,
      forbidNonWhitelisted: true, // Forbid any unknown body fields (strict sanitize)
    }),
  );

  // 5. Register Global Exception Filter for standardized enterprise JSON errors
  app.useGlobalFilters(new GlobalExceptionFilter());

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
