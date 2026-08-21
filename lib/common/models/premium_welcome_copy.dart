String premiumWelcomeMessage({
  required bool isComplimentary,
  String? sourceName,
  bool proudlySupportsSource = false,
}) {
  final normalizedSourceName = sourceName?.trim();
  final sourceIsKnown = normalizedSourceName?.isNotEmpty == true;

  if (isComplimentary) {
    return sourceIsKnown
        ? '$normalizedSourceName has welcomed you with a complimentary 12-month Premium Membership.'
        : 'Your complimentary 12-month Premium Membership is now active.';
  }

  if (!sourceIsKnown) {
    return 'Your 12-month Premium Membership is now active.';
  }

  return proudlySupportsSource
      ? 'Your 12-month Premium Membership is now active, proudly supporting $normalizedSourceName.'
      : 'You joined TouristSaver through $normalizedSourceName.\n\nYour 12-month Premium Membership is now active.';
}
