import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../providers/booking_providers.dart';
import '../states/booking_state.dart';

class BookingController extends Notifier<BookingState> {
  @override
  BookingState build() {
    // Automatically fetch bookings on initialization
    Future.microtask(() => fetchBookings());
    return const BookingState(isLoading: true);
  }

  Future<void> fetchBookings() async {
    state = state.copyWith(isLoading: true);
    try {
      final getBookingsUseCase = ref.read(getBookingsUseCaseProvider);
      final bookingsList = await getBookingsUseCase();
      state = BookingState(bookings: bookingsList, isLoading: false);
    } catch (e) {
      state = BookingState(
        bookings: state.bookings,
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final bookingControllerProvider =
    NotifierProvider<BookingController, BookingState>(BookingController.new);
