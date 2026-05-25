import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EmergencyDispatchModule } from './modules/emergency-dispatch/emergency-dispatch.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      url:
        process.env.DATABASE_URL ||
        'postgresql://khidma_user:khidma_password@localhost:5432/khidma_db',
      autoLoadEntities: true,
      synchronize: true, // Automatically synchronize entities to Postgres schema for dev/test
    }),
    EmergencyDispatchModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

