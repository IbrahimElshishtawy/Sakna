import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EmergencyDispatchModule } from './modules/emergency-dispatch/emergency-dispatch.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [EmergencyDispatchModule, AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

