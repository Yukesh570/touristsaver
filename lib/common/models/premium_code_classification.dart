double membershipOfferDiscountPercent(dynamic discount) {
  final parsed = double.tryParse(discount?.toString() ?? '') ?? 0;
  return parsed.clamp(0, 100).toDouble();
}

bool isExplicitComplimentaryMembershipOffer({
  required bool isGiveaway,
  required bool? premiumCodeIsPaid,
  required double discountPercent,
}) {
  return isGiveaway ||
      premiumCodeIsPaid == false ||
      (premiumCodeIsPaid == null && discountPercent == 100);
}

double effectiveMembershipOfferDiscountPercent({
  required dynamic discount,
  required bool isGiveaway,
  required bool? premiumCodeIsPaid,
}) {
  final discountPercent = membershipOfferDiscountPercent(discount);
  final isComplimentary = isExplicitComplimentaryMembershipOffer(
    isGiveaway: isGiveaway,
    premiumCodeIsPaid: premiumCodeIsPaid,
    discountPercent: discountPercent,
  );

  if (isComplimentary) return 100;

  // A 100% payment bypass must be explicit. If a percentage code is not marked
  // as complimentary/free, do not let a stale or mis-shaped discount value turn
  // it into a giveaway.
  if (discountPercent == 100) return 0;

  return discountPercent;
}
