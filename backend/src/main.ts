import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  // Sentry Initialization Boilerplate
  // Sentry.init({
  //   dsn: process.env.SENTRY_DSN,
  //   tracesSampleRate: 1.0,
  // });

  const app = await NestFactory.create(AppModule);
  
  // Enable global validation pipe with whitelisting (strips extra fields for security)
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
