import { EmergencyEntity } from './emergency.entity';

export const EMERGENCY_REPOSITORY = 'EMERGENCY_REPOSITORY';

export interface IEmergencyRepository {
  create(emergency: EmergencyEntity): Promise<EmergencyEntity>;
  findById(id: string): Promise<EmergencyEntity | null>;
  update(id: string, emergency: Partial<EmergencyEntity>): Promise<EmergencyEntity>;
  findNearbyUnassigned(lat: number, lng: number, radiusKm: number): Promise<EmergencyEntity[]>;
}
