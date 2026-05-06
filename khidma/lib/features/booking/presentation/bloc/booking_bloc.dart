import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  // In a real app, you would inject use cases here.
  // e.g., final SubmitBookingUseCase _submitBookingUseCase;

  BookingBloc() : super(const BookingState.initial()) {
    on<BookingEvent>(
      (event, emit) async {
        await event.map(
          started: (e) async {
            emit(const BookingState.initial());
          },
          serviceDetailsSubmitted: (e) async {
            emit(const BookingState.loading());
            // Simulate some processing or validation
            await Future.delayed(const Duration(milliseconds: 500));
            emit(BookingState.serviceDetailsEntered(details: e.details));
          },
          scheduleSelected: (e) async {
            await state.maybeMap(
              serviceDetailsEntered: (currentState) async {
                emit(const BookingState.loading());
                await Future.delayed(const Duration(milliseconds: 500));
                emit(BookingState.scheduleConfirmed(
                    details: currentState.details,
                    scheduledDate: e.scheduledDate));
              },
              orElse: () async {
                emit(const BookingState.failure(message: 'Invalid state to select schedule.'));
              },
            );
          },
          paymentSubmitted: (e) async {
            await state.maybeMap(
              scheduleConfirmed: (currentState) async {
                emit(const BookingState.loading());

                // Simulate network request to process payment and booking
                await Future.delayed(const Duration(seconds: 1));

                // Simulate success
                emit(const BookingState.success(bookingId: 'BOOKING_12345'));
              },
              orElse: () async {
                emit(const BookingState.failure(message: 'Invalid state to submit payment.'));
              },
            );
          },
          statusUpdated: (e) async {
             // Handle real-time updates via WebSockets/Stream
             emit(BookingState.updating(currentStatus: e.status));
          },
        );
      },
      transformer: sequential(),
    );
  }
}
