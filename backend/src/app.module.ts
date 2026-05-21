import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { EmergencyDispatchModule } from './modules/emergency-dispatch/emergency-dispatch.module';

@Module({
  imports: [EmergencyDispatchModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
