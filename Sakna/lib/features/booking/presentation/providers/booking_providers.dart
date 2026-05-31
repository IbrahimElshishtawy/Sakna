import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl();
});

final getBookingsUseCaseProvider = Provider<GetBookingsUseCase>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return GetBookingsUseCase(repository);
});
