import 'package:dio/dio.dart';
import 'package:new_piiink/constants/helper.dart';
import 'package:new_piiink/constants/url_end_point.dart';
import 'package:new_piiink/models/response/agreement_res.dart';

import '../../../constants/pref.dart';
import '../../../constants/pref_key.dart';

class DioAgreement {
  // Getting Terms and Conditions
  Future<AgreementResModel?> getAgreement() async {
    String firstChoseCountryId = await Pref().readData(key: saveCountryID) ??
        await Pref().readData(key: userChosenLocationID);
    try {
      final Dio dio = await getClientNoToken();
      Response<String> response =
          await dio.get('$agreement/$firstChoseCountryId');
      return agreementResModelFromJson(response.data!);
    } catch (e) {
      return null;
    }
  }
}
