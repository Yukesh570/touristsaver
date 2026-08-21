import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/premium_welcome_copy.dart';

void main() {
  test('recognises a source for a complimentary membership', () {
    expect(
      premiumWelcomeMessage(
        isComplimentary: true,
        sourceName: 'GC Jetski',
      ),
      'GC Jetski has welcomed you with a complimentary 12-month Premium Membership.',
    );
  });

  test('uses the anonymous complimentary message without a source', () {
    expect(
      premiumWelcomeMessage(isComplimentary: true),
      'Your complimentary 12-month Premium Membership is now active.',
    );
  });

  test('recognises an introducer for a paid membership', () {
    expect(
      premiumWelcomeMessage(
        isComplimentary: false,
        sourceName: 'Community Club',
      ),
      'You joined TouristSaver through Community Club.\n\nYour 12-month Premium Membership is now active.',
    );
  });

  test('uses the standard active message without a source', () {
    expect(
      premiumWelcomeMessage(isComplimentary: false),
      'Your 12-month Premium Membership is now active.',
    );
  });

  test('recognises a community fundraising source', () {
    expect(
      premiumWelcomeMessage(
        isComplimentary: false,
        sourceName: 'Local Community Club',
        proudlySupportsSource: true,
      ),
      'Your 12-month Premium Membership is now active, proudly supporting Local Community Club.',
    );
  });
}
