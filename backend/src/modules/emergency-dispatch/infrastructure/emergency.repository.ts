import { Injectable } from '@nestjs/common';
import { IEmergencyRepository } from '../domain/emergency.repository.interface';
import { EmergencyEntity } from '../domain/emergency.entity';

@Injectable()
export class EmergencyRepository implements IEmergencyRepository {
  private inMemoryDb: EmergencyEntity[] = [];

  async create(emergency: EmergencyEntity): Promise<EmergencyEntity> {
    emergency.id = Math.random().toString(36).substring(7);
    this.inMemoryDb.push(emergency);
    return emergency;
  }

  async findById(id: string): Promise<EmergencyEntity | null> {
    return this.inMemoryDb.find((e) => e.id === id) || null;
  }

  async update(id: string, updateData: Partial<EmergencyEntity>): Promise<EmergencyEntity> {
    const index = this.inMemoryDb.findIndex((e) => e.id === id);
    if (index === -1) throw new Error('Emergency not found');

    this.inMemoryDb[index] = Object.assign(this.inMemoryDb[index], updateData);
    return this.inMemoryDb[index];
  }

  async findNearbyUnassigned(lat: number, lng: number, radiusKm: number): Promise<EmergencyEntity[]> {
    // Boilerplate stub: In Postgres + PostGIS, this would be a ST_DWithin query
    return this.inMemoryDb.filter(e => e.status === 'pending' && !e.isAssigned());
  }
}
