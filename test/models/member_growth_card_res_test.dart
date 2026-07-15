import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/member_growth_card_res.dart';

void main() {
  group('MemberGrowthCardResModel', () {
    test('parses eligible growth card metrics', () {
      final response = MemberGrowthCardResModel.fromJson({
        'status': 'Success',
        'data': {
          'eligible': true,
          'recognitionLevel': 'Silver',
          'title': 'Your Community Impact',
          'membersIntroduced': 38,
          'activeMembers': 29,
          'communitySavings': {
            'amount': 3420,
            'currency': 'AUD',
          },
          'merchantsIntroduced': 7,
        },
      });

      expect(response.status, 'Success');
      expect(response.data?.eligible, isTrue);
      expect(response.data?.recognitionLevel, 'Silver');
      expect(response.data?.title, 'Your Community Impact');
      expect(response.data?.membersIntroduced, 38);
      expect(response.data?.activeMembers, 29);
      expect(response.data?.communitySavings.amount, 3420);
      expect(response.data?.communitySavings.currency, 'AUD');
      expect(response.data?.merchantsIntroduced, 7);
    });

    test('parses ineligible members without metrics', () {
      final response = MemberGrowthCardResModel.fromJson({
        'status': 'Success',
        'data': {
          'eligible': false,
          'recognitionLevel': null,
        },
      });

      expect(response.data?.eligible, isFalse);
      expect(response.data?.recognitionLevel, isNull);
      expect(response.data?.membersIntroduced, 0);
      expect(response.data?.activeMembers, 0);
      expect(response.data?.communitySavings.amount, 0);
      expect(response.data?.communitySavings.currency, 'AUD');
      expect(response.data?.merchantsIntroduced, 0);
    });
  });
}
