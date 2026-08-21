import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:touristsaver/constants/helper.dart';
import 'package:touristsaver/constants/url_end_point.dart';

class DiscoveryContinuationIntent {
  const DiscoveryContinuationIntent({
    required this.clientSecret,
    required this.isFree,
    required this.completed,
  });

  final String? clientSecret;
  final bool isFree;
  final bool completed;
}

class DiscoveryContinuationDio {
  Future<DiscoveryContinuationIntent?> createPaymentIntent(
    int entitlementId,
  ) async {
    try {
      final Dio dio = await getClient();
      final Response<dynamic> response = await dio.post(
        discoveryContinuationPaymentIntent,
        data: {'entitlementId': entitlementId},
      );
      final dynamic decoded = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      if (decoded is! Map) return null;
      final dynamic rawData = decoded['data'];
      if (rawData is! Map) return null;
      final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);
      return DiscoveryContinuationIntent(
        clientSecret: data['clientSecret']?.toString(),
        isFree: data['isFree'] == true,
        completed: data['completed'] == true,
      );
    } catch (_) {
      return null;
    }
  }
}
