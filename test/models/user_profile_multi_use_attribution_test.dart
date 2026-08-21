import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/user_detail_res.dart';

void main() {
  test('parses persistent Multi-Use profile attribution', () {
    final profile = UserProfileResModel.fromJson({
      'data': {
        'multiUsePremiumAttribution': {
          'code': 'SAVE50GCTM',
          'appWelcomeGreeting': 'Gold Coast Tourist Magazine',
        },
        'results': {'memberType': 'premium'},
      },
    });

    expect(profile.data?.multiUsePremiumAttribution?.code, 'SAVE50GCTM');
    expect(profile.data?.multiUsePremiumAttribution?.appWelcomeGreeting,
        'Gold Coast Tourist Magazine');
  });

  test('leaves legacy and ordinary profiles unchanged when field is absent', () {
    final profile = UserProfileResModel.fromJson({
      'data': {'results': {'memberType': 'premium'}},
    });
    expect(profile.data?.multiUsePremiumAttribution, isNull);
  });
}
