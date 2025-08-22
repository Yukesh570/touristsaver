import 'package:dio/dio.dart';

import '../../common/app_variables.dart';
import '../../constants/helper.dart';
import '../../constants/url_end_point.dart';
import '../../models/response/get_lang_res_model.dart';

class DioLang {
// Get Lang Data
  Future<GetLangResModel?> getLangData() async {
    try {
      Dio dio = await getClientNoToken();
      Response<String> response = await dio.get(getActiveLang);
      return getLangResModelFromJson(response.data!);
    } catch (e) {
      // print('Error in showing the lang data');
      return null;
    }
  }

  // Post Lang Data
  Future<dynamic> postChoosenLang() async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.patch(
        patchChoosenLanguage,
        data: {"selectedAppLang": AppVariables.selectedLanguageNow},
      );
      // log(response.data!);
      return response.data!;
    } catch (e) {
      // print('Error in showing the lang data');
      return null;
    }
  }
}
