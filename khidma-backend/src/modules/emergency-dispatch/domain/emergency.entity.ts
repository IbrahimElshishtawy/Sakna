export class EmergencyEntity {
  id: string;
  clientId: string;
  helperId?: string;
  serviceType: string;
  description: string;
  isUrgent: boolean;
  scheduledAt: Date;
  status: 'pending' | 'matched' | 'in_progress' | 'completed' | 'disputed';
  location: { lat: number; lng: number };

  constructor(partial: Partial<EmergencyEntity>) {
    Object.assign(this, partial);
    this.isUrgent = true; // By definition in this module
  }

  isAssigned(): boolean {
    return !!this.helperId;
  }
}
