import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  // Sentry Initialization Boilerplate
  // Sentry.init({
  //   dsn: process.env.SENTRY_DSN,
  //   tracesSampleRate: 1.0,
  // });

  const app = await NestFactory.create(AppModule);
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
