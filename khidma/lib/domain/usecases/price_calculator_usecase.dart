class PriceCalculatorUseCase {
  double call({
    required double basePrice,
    required double addOns,
    required double serviceFeePercentage,
    required double promoCodeDiscount,
  }) {
    final subtotal = basePrice + addOns;
    final serviceFee = subtotal * (serviceFeePercentage / 100);
    final totalBeforeDiscount = subtotal + serviceFee;

    // Ensure discount doesn't make total negative
    final finalTotal = totalBeforeDiscount - promoCodeDiscount;
    return finalTotal < 0 ? 0 : finalTotal;
  }
}
