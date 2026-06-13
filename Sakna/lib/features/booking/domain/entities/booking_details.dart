class BookingDetails {
  final DateTime? date;
  final String? timeSlot;
  final bool isRecurring;
  final String? writtenNotes;
  final List<String> photoPaths;
  final String? voiceNotePath;
  final String? addressLabel;
  final String? addressDetails;
  final String? promoCode;
  final bool useLoyaltyPoints;
  final String? paymentMethodId;

  const BookingDetails({
    this.date,
    this.timeSlot,
    this.isRecurring = false,
    this.writtenNotes,
    this.photoPaths = const [],
    this.voiceNotePath,
    this.addressLabel,
    this.addressDetails,
    this.promoCode,
    this.useLoyaltyPoints = false,
    this.paymentMethodId,
  });

  BookingDetails copyWith({
    DateTime? date,
    String? timeSlot,
    bool? isRecurring,
    String? writtenNotes,
    List<String>? photoPaths,
    String? voiceNotePath,
    String? addressLabel,
    String? addressDetails,
    String? promoCode,
    bool? useLoyaltyPoints,
    String? paymentMethodId,
  }) {
    return BookingDetails(
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      isRecurring: isRecurring ?? this.isRecurring,
      writtenNotes: writtenNotes ?? this.writtenNotes,
      photoPaths: photoPaths ?? this.photoPaths,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      addressLabel: addressLabel ?? this.addressLabel,
      addressDetails: addressDetails ?? this.addressDetails,
      promoCode: promoCode ?? this.promoCode,
      useLoyaltyPoints: useLoyaltyPoints ?? this.useLoyaltyPoints,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    );
  }
}
