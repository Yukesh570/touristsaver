import 'package:flutter/foundation.dart';

class MerchantDiscoveryLaunchIntent {
  const MerchantDiscoveryLaunchIntent({
    required this.token,
    this.categoryId,
    this.categoryName,
    this.openSubcategorySelector = true,
    this.focusSearch = false,
    this.showBestOffers = false,
    this.publicDealsOnly = false,
  });

  final int token;
  final int? categoryId;
  final String? categoryName;
  final bool openSubcategorySelector;
  final bool focusSearch;
  final bool showBestOffers;
  final bool publicDealsOnly;
}

class MerchantDiscoveryTabRequest {
  const MerchantDiscoveryTabRequest({
    required this.token,
    required this.page,
  });

  final int token;
  final int page;
}

class MerchantDiscoveryIntentStore {
  MerchantDiscoveryIntentStore._();

  static int _nextToken = 0;
  static int _nextTabToken = 0;
  static MerchantDiscoveryLaunchIntent? _pendingIntent;
  static final ValueNotifier<MerchantDiscoveryTabRequest?> bottomTabRequest =
      ValueNotifier<MerchantDiscoveryTabRequest?>(null);

  static MerchantDiscoveryLaunchIntent? get pendingIntent => _pendingIntent;

  static void requestBottomTab(int page) {
    bottomTabRequest.value = MerchantDiscoveryTabRequest(
      token: ++_nextTabToken,
      page: page,
    );
  }

  static void clearBottomTabRequest({int? token}) {
    final MerchantDiscoveryTabRequest? request = bottomTabRequest.value;
    if (request == null) return;
    if (token != null && request.token != token) return;
    bottomTabRequest.value = null;
  }

  static void launchCategory({
    required int categoryId,
    required String categoryName,
    bool openSubcategorySelector = true,
    bool publicDealsOnly = false,
  }) {
    _pendingIntent = MerchantDiscoveryLaunchIntent(
      token: ++_nextToken,
      categoryId: categoryId,
      categoryName: categoryName,
      openSubcategorySelector: openSubcategorySelector,
      publicDealsOnly: publicDealsOnly,
    );
  }

  static void focusSearch() {
    _pendingIntent = MerchantDiscoveryLaunchIntent(
      token: ++_nextToken,
      focusSearch: true,
    );
  }

  static void launchBestOffers() {
    _pendingIntent = MerchantDiscoveryLaunchIntent(
      token: ++_nextToken,
      showBestOffers: true,
    );
  }

  static MerchantDiscoveryLaunchIntent? consume(int token) {
    final MerchantDiscoveryLaunchIntent? intent = _pendingIntent;
    if (intent == null || intent.token != token) return null;
    _pendingIntent = null;
    return intent;
  }

  static void clear() {
    _pendingIntent = null;
  }
}
