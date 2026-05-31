import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUseCase {
  final BookingRepository _repository;

  const GetBookingsUseCase(this._repository);

  Future<List<Booking>> call() async {
    return _repository.getBookings();
  }
}
