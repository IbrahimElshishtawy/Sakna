import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  @override
  Future<List<Booking>> getBookings() async {
    // Simulate network delay to give a native professional feel with shimmer loading
    await Future.delayed(const Duration(milliseconds: 600));

    // Return empty list to trigger the premium empty state card shown in the screenshot
    return <Booking>[];

    /*
    // To test mock bookings list, uncomment the following block:
    return [
      Booking(
        id: '1',
        serviceName: 'تنظيف عميق للمنزل',
        providerName: 'شركة النور للخدمات',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        price: 250.0,
        status: BookingStatus.active,
      ),
      Booking(
        id: '2',
        serviceName: 'صيانة مكيف سبليت',
        providerName: 'المهندس أحمد علي',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        price: 150.0,
        status: BookingStatus.completed,
      ),
    ];
    */
  }
}
