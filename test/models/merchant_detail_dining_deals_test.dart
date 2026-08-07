import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/detail_res.dart';

void main() {
  test('parses published dining deal offers from merchant detail', () {
    final MerchantDetailResModel detail = MerchantDetailResModel.fromJson({
      'status': 'Success',
      'data': {
        'id': 42,
        'merchantName': 'House of Brews',
        'merchantListingType': 'discount_offer',
        'maxDiscount': '10',
        'publishedDiningDealOffers': [
          {
            'id': 7,
            'externalOfferRef': 'hob-wednesday',
            'title': 'Wednesday Wings',
            'description': 'A midweek venue special.',
            'dayOfWeek': 'wednesday',
            'startTime': '17:00:00',
            'endTime': '21:00:00',
            'offerPrice': 15,
            'regularPrice': '22.50',
            'offerType': 'set_price',
            'conditions': 'Dine in only.',
            'bookingRequired': true,
            'startDate': '2026-08-01',
            'endDate': '2026-12-31',
            'ongoingStatus': 'ongoing',
            'sourceUrl': 'https://example.com/wednesday',
          },
        ],
      },
    });

    expect(detail.data?.maxDiscount, 10);
    expect(detail.data?.publishedDiningDealOffers, hasLength(1));
    final DiningDealOffer offer = detail.data!.publishedDiningDealOffers.single;
    expect(offer.title, 'Wednesday Wings');
    expect(offer.dayOfWeek, 'wednesday');
    expect(offer.startTime, '17:00:00');
    expect(offer.endTime, '21:00:00');
    expect(offer.offerPrice, 15);
    expect(offer.regularPrice, 22.5);
    expect(offer.conditions, 'Dine in only.');
    expect(offer.bookingRequired, isTrue);
    expect(offer.sourceUrl, 'https://example.com/wednesday');
  });

  test('missing or malformed published dining deals become an empty list', () {
    expect(
      MerchantDetailResModel.fromJson({'data': <String, dynamic>{}})
          .data
          ?.publishedDiningDealOffers,
      isEmpty,
    );
    expect(
      MerchantDetailResModel.fromJson({
        'data': {'publishedDiningDealOffers': 'not-a-list'},
      }).data?.publishedDiningDealOffers,
      isEmpty,
    );
  });
}
