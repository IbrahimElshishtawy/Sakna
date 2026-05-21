import { Module } from '@nestjs/common';
import { EmergencyController } from './presentation/emergency.controller';
import { EmergencyUseCase } from './application/emergency.usecase';
import { EmergencyRepository } from './infrastructure/emergency.repository';
import { EMERGENCY_REPOSITORY } from './domain/emergency.repository.interface';

@Module({
  controllers: [EmergencyController],
  providers: [
    EmergencyUseCase,
    {
      provide: EMERGENCY_REPOSITORY,
      useClass: EmergencyRepository,
    },
  ],
})
export class EmergencyDispatchModule {}
