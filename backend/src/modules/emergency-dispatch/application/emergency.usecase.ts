import { Injectable, Inject } from '@nestjs/common';
import { EmergencyEntity } from '../domain/emergency.entity';
import type { IEmergencyRepository } from '../domain/emergency.repository.interface';
import { EMERGENCY_REPOSITORY } from '../domain/emergency.repository.interface';

export class CreateEmergencyDto {
  clientId: string;
  serviceType: string;
  description: string;
  lat: number;
  lng: number;
}

@Injectable()
export class EmergencyUseCase {
  constructor(
    @Inject(EMERGENCY_REPOSITORY)
    private readonly emergencyRepository: IEmergencyRepository,
  ) {}

  async createEmergencyRequest(dto: CreateEmergencyDto): Promise<EmergencyEntity> {
    const emergency = new EmergencyEntity({
      clientId: dto.clientId,
      serviceType: dto.serviceType,
      description: dto.description,
      location: { lat: dto.lat, lng: dto.lng },
      status: 'pending',
      scheduledAt: new Date(),
    });

    // In a real scenario, this is where we might:
    // 1. Calculate price multiplier (1.5x)
    // 2. Publish a Redis pub/sub event or Socket.io event to nearby helpers

    return this.emergencyRepository.create(emergency);
  }

  async getUnassignedEmergencies(lat: number, lng: number, radiusKm = 10): Promise<EmergencyEntity[]> {
    return this.emergencyRepository.findNearbyUnassigned(lat, lng, radiusKm);
  }
}
