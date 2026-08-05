import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/features/details/models/public_deal_presentation.dart';

void main() {
  test('public deal missing and sentinel phone numbers are hidden', () {
    for (final String? value in <String?>[
      null,
      '',
      '   ',
      '0000000',
      '000-0000',
      'N/A',
      'Unknown',
      'Not published',
      '-',
    ]) {
      expect(usablePublicDealPhone(value), isNull, reason: '$value');
    }
    expect(usablePublicDealPhone('07 5532 1155'), '07 5532 1155');
  });

  test('all seven public deal weekdays retain their individual wording', () {
    const String raw = 'Monday: 09:00-17:00\n'
        'Tuesday: Closed\n'
        'Wednesday: 09:00-12:00, 17:00-21:00\n'
        'Thursday: Not published\n'
        'Friday: 10:00-22:00\n'
        'Saturday: 10:00-22:00\n'
        'Sunday: 10:00-16:00';
    final List<PublicDealOpeningHoursRow> rows =
        parsePublicDealOpeningHours(raw);
    expect(rows, hasLength(7));
    expect(rows.map((row) => row.weekday), publicDealWeekdays);
    expect(rows[1].value, 'Closed');
    expect(rows[2].value, '09:00-12:00, 17:00-21:00');
    expect(rows[3].value, 'Not published');
    expect(publicDealHoursForWeekday(raw, DateTime.wednesday).value,
        '09:00-12:00, 17:00-21:00');
  });

  test('new hours presentation is gated to public deals only', () {
    expect(usesPublicDealPresentation('public_deal'), isTrue);
    expect(usesPublicDealPresentation('discount_offer'), isFalse);
    expect(usesPublicDealPresentation('concierge_listing'), isFalse);
    expect(usesPublicDealPresentation(null), isFalse);
  });
}
