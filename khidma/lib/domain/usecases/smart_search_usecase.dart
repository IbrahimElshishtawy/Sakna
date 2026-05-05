import '../../models/khidma_user.dart';

class SmartSearchUseCase {
  Stream<List<KhidmaUser>> call({
    required String category,
    required double maxDistance,
    required double maxPrice,
    required double minRating,
    required bool isAvailable,
  }) async* {
    // Simulated Stream representing filtered data
    // In reality, this would connect to a repository that filters data from an API or local DB
    yield [
      KhidmaUser(
        id: 'user1',
        name: 'Provider 1',
        email: 'provider1@example.com',
        role: 'provider',
        location: null,
        urgencyLevel: 'normal'
      )
    ];
  }
}
