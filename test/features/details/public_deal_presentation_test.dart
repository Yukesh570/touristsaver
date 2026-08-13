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

  test('merchant detail website action only accepts valid web URLs', () {
    for (final String? value in <String?>[
      null,
      '',
      '   ',
      'not a website',
      'mailto:venue@example.com',
      'https://',
    ]) {
      expect(usableMerchantWebsite(value), isNull, reason: '$value');
    }

    expect(usableMerchantWebsite('https://venue.example/deals'),
        'https://venue.example/deals');
    expect(usableMerchantWebsite('venue.example'), 'venue.example');
    expect(
      usableMerchantWebsite('https://finnmccoolsgoldcoast.com.au/whats-on/'),
      'https://finnmccoolsgoldcoast.com.au/whats-on/',
    );
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

  test('unstructured public deal hours do not create placeholder rows', () {
    for (final String? raw in <String?>[
      null,
      '',
      '   ',
      'Not published',
      'Hours unavailable',
      'See venue website for current opening hours',
      '9:00am - 5:00pm',
      'Monday:',
      'Monday: ; Tuesday:',
    ]) {
      expect(parsePublicDealOpeningHours(raw), isEmpty, reason: '$raw');
    }
  });

  test('one valid public deal day still expands to the seven-day view', () {
    final List<PublicDealOpeningHoursRow> rows =
        parsePublicDealOpeningHours('Mon: 9:00am - 5:00pm');

    expect(rows, hasLength(7));
    expect(rows.first.value, '9:00am - 5:00pm');
    expect(rows.skip(1).map((row) => row.value), everyElement('Not published'));
  });

  test('new hours presentation is gated to public deals only', () {
    expect(usesPublicDealPresentation('public_deal'), isTrue);
    expect(usesPublicDealPresentation('discount_offer'), isFalse);
    expect(usesPublicDealPresentation('concierge_listing'), isFalse);
    expect(usesPublicDealPresentation(null), isFalse);
  });

  test('standard Venue Info is gated to Dining Deals and member offers', () {
    expect(usesStandardVenueInfoPresentation('public_deal'), isTrue);
    expect(usesStandardVenueInfoPresentation('discount_offer'), isTrue);
    expect(usesStandardVenueInfoPresentation('concierge_listing'), isFalse);
    expect(usesStandardVenueInfoPresentation(null), isFalse);
  });
}
