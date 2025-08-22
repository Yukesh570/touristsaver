// import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../constants/helper.dart';
import '../../../constants/url_end_point.dart';
import '../../../models/response/premium_code_top_up_history.dart';

class PremiumTopUpRepository {
  Future<PremiumCodeTopUpHistory?> fetchPremiumCodeTopUpHistory(
      String latestDate, String previousDate) async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.get(
          '$premiumTopUpHistory?appliedDate__between=$previousDate:$latestDate&order_by=appliedDate');
      // log(response.data!);
      return premiumCodeTopUpHistoryFromJson(response.data!);
    } catch (ex) {
      // if (ex is DioException) {
      //   log('ERROR: ${ex.response?.data}');
      //   log('ERROR: ${ex.response?.headers}');
      // }
      // log('premium code error: ${ex.toString()}');
      return null;
    }
  }
}
