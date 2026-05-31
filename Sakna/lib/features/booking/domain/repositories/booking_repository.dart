import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();
}
