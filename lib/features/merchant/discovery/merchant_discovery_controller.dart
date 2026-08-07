import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/common/models/merchant_summary.dart';
import 'package:touristsaver/common/services/location_service.dart';
import 'package:touristsaver/features/home_page/services/home_dio.dart';
import 'package:touristsaver/features/merchant/discovery/merchant_discovery_state.dart';
import 'package:touristsaver/features/merchant/services/dio_merchant.dart';
import 'package:touristsaver/models/request/nearby_req.dart';
import 'package:touristsaver/models/request/mark_fav_req.dart';
import 'package:touristsaver/models/response/common_res.dart';

class MerchantDiscoveryController extends ChangeNotifier {
  MerchantDiscoveryState state = const MerchantDiscoveryState();

  Timer? _searchDebounce;
  int _requestId = 0;
  bool _disposed = false;
  List<MerchantSummary> _rawResults = [];

  Future<void> loadSearch(String value) async {
    final String query = value.trim();
    final int requestId = ++_requestId;
    _searchDebounce?.cancel();

    if (query.length < 3) {
      _rawResults = [];
      _emit(
        state.copyWith(
          source: MerchantDiscoverySource.none,
          searchText: '',
          selectedCategoryId: null,
          selectedCategoryName: null,
          isLoading: false,
          error: null,
          results: const [],
        ),
      );
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      _emit(
        state.copyWith(
          source: MerchantDiscoverySource.search,
          searchText: query,
          selectedCategoryId: null,
          selectedCategoryName: null,
          isLoading: true,
          error: null,
          results: const [],
        ),
      );

      final response = await DioHome().getSearched(
        name: query,
        diningDealsOnly: state.diningDealsOnly,
      );
      if (_isStale(requestId) ||
          state.source != MerchantDiscoverySource.search ||
          state.searchText != query) {
        return;
      }

      final List<MerchantSummary> results = (response?.merchants ?? [])
          .map(
            (merchant) => MerchantSummaryAdapters.fromSearchMerchant(
              merchant,
              currentLatitude: AppVariables.latitude,
              currentLongitude: AppVariables.longitude,
            ),
          )
          .whereType<MerchantSummary>()
          .toList();
      _rawResults = state.diningDealsOnly
          ? deduplicateMerchantSummaries(results)
          : results;

      _emit(
        state.copyWith(
          isLoading: false,
          error: null,
          results: _filteredAndSortedResults(),
        ),
      );
    });
  }

  Future<void> loadCategory(int categoryId, String categoryName) async {
    _cancelSearch();
    final int requestId = ++_requestId;
    _emit(
      state.copyWith(
        source: MerchantDiscoverySource.category,
        searchText: '',
        selectedCategoryId: categoryId,
        selectedCategoryName: categoryName,
        isLoading: true,
        error: null,
        results: const [],
      ),
    );

    final response = await DioHome().getAllMerchant(
      pageNumber: 1,
      categoryId: categoryId,
      diningDealsOnly: state.diningDealsOnly,
    );
    if (_isStale(requestId)) return;

    final List<MerchantSummary> results = (response?.data ?? [])
        .map(
          (merchant) => MerchantSummaryAdapters.fromMerchantGetAll(
            merchant,
            currentLatitude: AppVariables.latitude,
            currentLongitude: AppVariables.longitude,
            categoryLabel: categoryName,
          ),
        )
        .whereType<MerchantSummary>()
        .toList();
    _rawResults =
        state.diningDealsOnly ? deduplicateMerchantSummaries(results) : results;

    _emit(
      state.copyWith(
        isLoading: false,
        error: null,
        results: _filteredAndSortedResults(),
      ),
    );
  }

  Future<void> loadNearMe() async {
    _cancelSearch();
    final int requestId = ++_requestId;
    double? latitude = AppVariables.latitude;
    double? longitude = AppVariables.longitude;

    if (latitude == null || longitude == null) {
      _rawResults = [];
      _emit(
        state.copyWith(
          source: MerchantDiscoverySource.nearMe,
          searchText: '',
          selectedCategoryId: null,
          selectedCategoryName: null,
          isLoading: true,
          error: null,
          results: const [],
        ),
      );

      final bool locationReady =
          await LocationService().enableLocationAndFetchCountry();
      if (_isStale(requestId)) return;

      latitude = AppVariables.latitude;
      longitude = AppVariables.longitude;
      if (!locationReady || latitude == null || longitude == null) {
        _emit(
          state.copyWith(
            isLoading: false,
            error:
                'Location is needed to show nearby merchants. Update your location and try again.',
            results: const [],
          ),
        );
        return;
      }
    }

    final double radius = state.selectedRadiusKm ?? 25;
    _emit(
      state.copyWith(
        source: MerchantDiscoverySource.nearMe,
        searchText: '',
        selectedCategoryId: null,
        selectedCategoryName: null,
        isLoading: true,
        error: null,
        results: const [],
      ),
    );

    final response = await DioHome().getNearbyOffers(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      diningDealsOnly: state.diningDealsOnly,
    );
    if (_isStale(requestId)) return;

    final List<MerchantSummary> results = (response?.data ?? [])
        .map(MerchantSummaryAdapters.fromNearbyViewAll)
        .whereType<MerchantSummary>()
        .toList();
    _rawResults =
        state.diningDealsOnly ? deduplicateMerchantSummaries(results) : results;

    _emit(
      state.copyWith(
        isLoading: false,
        error: null,
        results: _filteredAndSortedResults(),
      ),
    );
  }

  Future<void> loadBestOffers() async {
    _cancelSearch();
    final int requestId = ++_requestId;
    double? latitude = AppVariables.latitude;
    double? longitude = AppVariables.longitude;

    _emit(
      state.copyWith(
        source: MerchantDiscoverySource.bestOffers,
        searchText: '',
        selectedCategoryId: null,
        selectedCategoryName: null,
        selectedRadiusKm: null,
        selectedSort: 'Best Offer',
        bestOfferFirst: true,
        isLoading: true,
        error: null,
        results: const [],
      ),
    );

    if (latitude == null || longitude == null) {
      final bool locationReady =
          await LocationService().enableLocationAndFetchCountry();
      if (_isStale(requestId)) return;

      latitude = AppVariables.latitude;
      longitude = AppVariables.longitude;
      if (!locationReady || latitude == null || longitude == null) {
        _rawResults = [];
        _emit(
          state.copyWith(
            isLoading: false,
            error:
                'Location is needed to show best offers nearby. Update your location and try again.',
            results: const [],
          ),
        );
        return;
      }
    }

    final response = await DioHome().getBestOffers(
      nearByLocationReqModel: NearByLocationReqModel(
        latitude: latitude,
        longitude: longitude,
        countryCode: AppVariables.countryCode,
        page: 1,
      ),
      diningDealsOnly: state.diningDealsOnly,
    );
    if (_isStale(requestId)) return;

    final List<MerchantSummary> results = (response?.data ?? [])
        .map(MerchantSummaryAdapters.fromNearby)
        .whereType<MerchantSummary>()
        .toList();
    _rawResults =
        state.diningDealsOnly ? deduplicateMerchantSummaries(results) : results;

    _emit(
      state.copyWith(
        isLoading: false,
        error: null,
        results: _filteredAndSortedResults(),
      ),
    );
  }

  Future<bool> toggleFavourite(MerchantSummary merchant) async {
    if (AppVariables.accessToken == null) return true;
    if (state.pendingFavouriteMerchantIds.contains(merchant.merchantId)) {
      return true;
    }

    final bool shouldAdd = merchant.isFavourite != true;
    _setFavouritePending(merchant.merchantId, true);

    try {
      final dynamic response = shouldAdd
          ? await DioMerchant().markFavouriteMerchants(
              markFavouriteReqModel: MarkFavouriteReqModel(
                merchantId: merchant.merchantId,
              ),
            )
          : await DioMerchant().removeFavouriteMerchants(
              merchantID: merchant.merchantId,
            );

      if (_disposed) return false;
      final bool success = response is CommonResModel
          ? response.status == 'Success'
          : response is SecondCommonResModel
              ? response.status == 'Success'
              : false;
      if (!success) return false;

      _rawResults = _rawResults
          .map(
            (item) => item.merchantId == merchant.merchantId
                ? item.copyWith(isFavourite: shouldAdd)
                : item,
          )
          .toList();
      _refreshVisibleResults();
      return true;
    } finally {
      _setFavouritePending(merchant.merchantId, false);
    }
  }

  void setSort(String sort) {
    _emit(
      state.copyWith(
        selectedSort: sort,
        bestOfferFirst: sort == 'Best Offer',
      ),
    );
    _refreshVisibleResults();
  }

  void setRadius(double? radius) {
    _emit(state.copyWith(selectedRadiusKm: radius));
    if (state.source == MerchantDiscoverySource.nearMe) {
      loadNearMe();
    } else {
      _refreshVisibleResults();
    }
  }

  void setBestOfferFirst(bool value) {
    _emit(
      state.copyWith(
        bestOfferFirst: value,
        selectedSort: value ? 'Best Offer' : 'Distance',
      ),
    );
    _refreshVisibleResults();
  }

  void setFavouritesOnly(bool value) {
    _emit(state.copyWith(favouritesOnly: value));
    _refreshVisibleResults();
  }

  void setDiningDealsOnly(bool value) {
    if (state.diningDealsOnly == value) return;
    _emit(state.copyWith(diningDealsOnly: value));
    switch (state.source) {
      case MerchantDiscoverySource.search:
        loadSearch(state.searchText);
      case MerchantDiscoverySource.category:
        if (state.selectedCategoryId != null &&
            state.selectedCategoryName != null) {
          loadCategory(state.selectedCategoryId!, state.selectedCategoryName!);
        }
      case MerchantDiscoverySource.nearMe:
        loadNearMe();
      case MerchantDiscoverySource.bestOffers:
        loadBestOffers();
      case MerchantDiscoverySource.none:
        break;
    }
  }

  void clear() {
    _cancelSearch();
    _requestId++;
    final int? categoryId = state.selectedCategoryId;
    final String? categoryName = state.selectedCategoryName;
    final bool preserveCategory =
        state.source == MerchantDiscoverySource.category &&
            categoryId != null &&
            categoryName != null;
    _emit(
      state.copyWith(
        source: preserveCategory
            ? MerchantDiscoverySource.category
            : MerchantDiscoverySource.none,
        searchText: preserveCategory ? state.searchText : '',
        selectedCategoryId: preserveCategory ? categoryId : null,
        selectedCategoryName: preserveCategory ? categoryName : null,
        selectedRadiusKm: null,
        selectedSort: 'Distance',
        bestOfferFirst: false,
        diningDealsOnly: false,
        favouritesOnly: false,
        isLoading: false,
        error: null,
        results: preserveCategory ? state.results : const [],
      ),
    );
    if (preserveCategory) {
      loadCategory(categoryId, categoryName);
    } else {
      _rawResults = [];
    }
  }

  void _refreshVisibleResults() {
    _emit(state.copyWith(results: _filteredAndSortedResults()));
  }

  void _setFavouritePending(int merchantId, bool isPending) {
    if (_disposed) return;
    final pendingIds = Set<int>.from(state.pendingFavouriteMerchantIds);
    if (isPending) {
      pendingIds.add(merchantId);
    } else {
      pendingIds.remove(merchantId);
    }
    _emit(state.copyWith(pendingFavouriteMerchantIds: pendingIds));
  }

  List<MerchantSummary> _filteredAndSortedResults() {
    List<MerchantSummary> results = List<MerchantSummary>.from(_rawResults);
    final double? radius = state.selectedRadiusKm;
    if (radius != null && state.source != MerchantDiscoverySource.nearMe) {
      results = results
          .where((merchant) =>
              merchant.distanceKm != null && merchant.distanceKm! <= radius)
          .toList();
    }

    if (state.favouritesOnly) {
      results =
          results.where((merchant) => merchant.isFavourite == true).toList();
    }

    if (state.bestOfferFirst) {
      results.sort((left, right) {
        final int offerCompare = _compareOffer(left, right);
        if (offerCompare != 0) return offerCompare;
        return _compareSelectedSort(left, right);
      });
    } else if (state.selectedSort == 'Distance') {
      results.sort(_compareDistance);
    } else if (state.selectedSort == 'Name') {
      results.sort(_compareName);
    }

    return results;
  }

  int _compareDistance(MerchantSummary left, MerchantSummary right) {
    final double leftDistance = left.distanceKm ?? double.infinity;
    final double rightDistance = right.distanceKm ?? double.infinity;
    return leftDistance.compareTo(rightDistance);
  }

  int _compareName(MerchantSummary left, MerchantSummary right) {
    return left.merchantName
        .toLowerCase()
        .compareTo(right.merchantName.toLowerCase());
  }

  int _compareOffer(MerchantSummary left, MerchantSummary right) {
    final double leftDiscount = _offerValue(left);
    final double rightDiscount = _offerValue(right);
    return rightDiscount.compareTo(leftDiscount);
  }

  double _offerValue(MerchantSummary merchant) {
    final double? discount = merchant.maxDiscount;
    return discount != null && discount > 0 ? discount : -1;
  }

  int _compareSelectedSort(MerchantSummary left, MerchantSummary right) {
    if (state.selectedSort == 'Name') return _compareName(left, right);
    return _compareDistance(left, right);
  }

  void _cancelSearch() {
    _searchDebounce?.cancel();
  }

  bool _isStale(int requestId) => _disposed || requestId != _requestId;

  void _emit(MerchantDiscoveryState nextState) {
    if (_disposed) return;
    state = nextState;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _searchDebounce?.cancel();
    super.dispose();
  }
}

List<MerchantSummary> deduplicateMerchantSummaries(
  Iterable<MerchantSummary> merchants,
) {
  final Set<int> seenIds = <int>{};
  return merchants
      .where((merchant) => seenIds.add(merchant.merchantId))
      .toList(growable: false);
}
