import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/merchant_summary.dart';
import 'package:touristsaver/features/merchant/discovery/merchant_discovery_controller.dart';

void main() {
  test(
      'dining deal results retain premium and value merchants without duplicates',
      () {
    const MerchantSummary premium = MerchantSummary(
      merchantId: 1,
      merchantName: 'House of Brews',
      merchantListingType: merchantListingTypeDiscountOffer,
    );
    const MerchantSummary value = MerchantSummary(
      merchantId: 2,
      merchantName: 'Value Venue',
      merchantListingType: merchantListingTypePublicDeal,
    );

    final List<MerchantSummary> results = deduplicateMerchantSummaries([
      premium,
      value,
      premium,
      value,
    ]);

    expect(results, hasLength(2));
    expect(results.map((merchant) => merchant.merchantId), [1, 2]);
    expect(results.first.isDiscountOffer, isTrue);
    expect(results.last.isPublicDeal, isTrue);
  });
}
