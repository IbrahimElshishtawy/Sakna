import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/booking_details.dart';
export '../../domain/entities/booking_details.dart';

class BookingFlowNotifier extends Notifier<BookingDetails> {
  @override
  BookingDetails build() {
    return const BookingDetails();
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void updateTimeSlot(String? timeSlot) {
    state = state.copyWith(timeSlot: timeSlot);
  }

  void toggleRecurring(bool isRecurring) {
    state = state.copyWith(isRecurring: isRecurring);
  }

  void updateWrittenNotes(String notes) {
    state = state.copyWith(writtenNotes: notes);
  }

  void addPhoto(String path) {
    final currentPhotos = List<String>.from(state.photoPaths);
    currentPhotos.add(path);
    state = state.copyWith(photoPaths: currentPhotos);
  }

  void removePhoto(int index) {
    final currentPhotos = List<String>.from(state.photoPaths);
    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      state = state.copyWith(photoPaths: currentPhotos);
    }
  }

  void updateVoiceNote(String? path) {
    state = state.copyWith(voiceNotePath: path);
  }

  void updateAddress(String label, String details) {
    state = state.copyWith(addressLabel: label, addressDetails: details);
  }

  void updatePromoCode(String? code) {
    state = state.copyWith(promoCode: code);
  }

  void toggleLoyaltyPoints(bool usePoints) {
    state = state.copyWith(useLoyaltyPoints: usePoints);
  }

  void updatePaymentMethod(String methodId) {
    state = state.copyWith(paymentMethodId: methodId);
  }

  void reset() {
    state = const BookingDetails();
  }
}

final bookingFlowProvider = NotifierProvider<BookingFlowNotifier, BookingDetails>(BookingFlowNotifier.new);
