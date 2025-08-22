import 'package:dio/dio.dart';
import 'package:new_piiink/constants/helper.dart';
import 'package:new_piiink/constants/url_end_point.dart';
import 'package:new_piiink/models/error_res.dart';
import 'package:new_piiink/models/request/recommend_mer_req.dart';
import 'package:new_piiink/models/response/recommend_mer_res.dart';

class DioRecommend {
  Future<dynamic> createRecommedMer(
      {required RecommendMerchantReqModel recommendMerchantReqModel}) async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.post(recommendMerURL,
          data: recommendMerchantReqModel.toJson());
      //  log(response.data!);
      return recommendMerchantResModelFromJson(response.data!);
    } on DioException catch (e) {
      return errorResModelFromJson(e.response?.data);
    } catch (err) {
      // print('Error in creating recommend merchant:$err');
      return null;
    }
  }
}
