import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/live_tracking_repository_impl.dart';
import '../../domain/repositories/live_tracking_repository.dart';
import '../../domain/usecases/get_live_tracking_usecase.dart';

final liveTrackingRepositoryProvider = Provider<LiveTrackingRepository>((ref) {
  return LiveTrackingRepositoryImpl();
});

final getLiveTrackingUseCaseProvider = Provider<GetLiveTrackingUseCase>((ref) {
  final repository = ref.watch(liveTrackingRepositoryProvider);
  return GetLiveTrackingUseCase(repository);
});
