import '../../domain/entities/booking.dart';

class BookingState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? errorMessage;

  const BookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEmpty => !isLoading && bookings.isEmpty && errorMessage == null;

  BookingState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
