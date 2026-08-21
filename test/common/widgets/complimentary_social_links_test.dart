import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/social_media_link.dart';

void main() {
  const links = [
    SocialMediaLink(
      platform: 'facebook',
      displayName: 'Facebook',
      url: 'https://facebook.com/touristsaver',
      sortOrder: 1,
    ),
  ];

  test('shows links only for a successful complimentary community welcome', () {
    expect(
      shouldShowComplimentarySocialLinks(
        communityWelcome: true,
        isComplimentary: true,
        links: links,
      ),
      isTrue,
    );
  });

  test('does not show links for paid or generic success screens', () {
    expect(
      shouldShowComplimentarySocialLinks(
        communityWelcome: true,
        isComplimentary: false,
        links: links,
      ),
      isFalse,
    );
    expect(
      shouldShowComplimentarySocialLinks(
        communityWelcome: false,
        isComplimentary: true,
        links: links,
      ),
      isFalse,
    );
  });

  test('hides the section when Global Admin has no active links', () {
    expect(
      shouldShowComplimentarySocialLinks(
        communityWelcome: true,
        isComplimentary: true,
        links: const [],
      ),
      isFalse,
    );
  });
}
