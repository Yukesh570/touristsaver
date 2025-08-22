import 'package:dio/dio.dart';
import 'package:new_piiink/constants/helper.dart';
import 'package:new_piiink/constants/url_end_point.dart';
import 'package:new_piiink/models/response/transaction_res.dart';

import '../../../common/app_variables.dart';

class DioTransaction {
  //Transaction
  Future<TransactionResModel?> transac(
    String previousDate,
    String latestDate,
  ) async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.get(
          '$userTransac?transactionDate__between=$previousDate:$latestDate&order_by=transactionDate&lang=${AppVariables.selectedLanguageNow}');

      // log(response.data!);
      return transactionResModelFromJson(response.data!);
    } catch (e) {
      return null;
    }
  }
}
