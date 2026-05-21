import { EmergencyUseCase } from './emergency.usecase';
import { IEmergencyRepository } from '../domain/emergency.repository.interface';
import { EmergencyEntity } from '../domain/emergency.entity';

describe('EmergencyUseCase', () => {
  let useCase: EmergencyUseCase;
  let repository: jest.Mocked<IEmergencyRepository>;

  beforeEach(() => {
    repository = {
      create: jest.fn(),
      findById: jest.fn(),
      update: jest.fn(),
      findNearbyUnassigned: jest.fn(),
    };
    useCase = new EmergencyUseCase(repository);
  });

  it('should create an emergency request and default to urgent', async () => {
    const dto = {
      clientId: 'client123',
      serviceType: 'plumbing',
      description: 'Pipe burst',
      lat: 24.7136,
      lng: 46.6753,
    };

    const mockEntity = new EmergencyEntity({
        ...dto,
        id: 'req1',
        status: 'pending',
        location: { lat: dto.lat, lng: dto.lng },
        scheduledAt: new Date()
    });

    repository.create.mockResolvedValue(mockEntity);

    const result = await useCase.createEmergencyRequest(dto);

    expect(repository.create).toHaveBeenCalled();
    expect(result.isUrgent).toBe(true);
    expect(result.status).toBe('pending');
  });
});
