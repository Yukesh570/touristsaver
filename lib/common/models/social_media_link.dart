class SocialMediaLink {
  const SocialMediaLink({
    required this.platform,
    required this.displayName,
    required this.url,
    required this.sortOrder,
  });

  final String platform;
  final String displayName;
  final String url;
  final int sortOrder;

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) =>
      SocialMediaLink(
        platform: json['platform']?.toString() ?? '',
        displayName: json['displayName']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        sortOrder: int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,
      );
}

bool shouldShowComplimentarySocialLinks({
  required bool communityWelcome,
  required bool isComplimentary,
  required List<SocialMediaLink> links,
}) =>
    communityWelcome && isComplimentary && links.isNotEmpty;
