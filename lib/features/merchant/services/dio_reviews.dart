// import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../constants/helper.dart';
import '../../../constants/url_end_point.dart';
import '../../../models/error_res.dart';
import '../../../models/request/rate_merchant_req.dart';
import '../../../models/response/get_all_merchant_reviews.dart';
import '../../../models/response/get_all_reviews_suggestion.dart';
import '../../../models/response/rate_merchant_res_model.dart';

class DioReviews {
  // Create Merchants Reviews
  Future<Either<ErrorResModel, RateMerchantResModel>?> createMerchantReviews(
      {required RateMerchantReqModel rateMerchantReqModel}) async {
    try {
      Dio dio = await getClient();
      // log(rateMerchantReqModel.toJson().toString());
      Response<String> response = await dio.post(createMerchantReviewsURL,
          data: rateMerchantReqModel.toJson());
      // log(response.data!);
      return Right(rateMerchantResModelFromJson(response.data!));
    } on DioException catch (e) {
      return Left(errorResModelFromJson(e.response?.data));
    } catch (err) {
      return null;
    }
  }

  // GetAll ReviewsText
  Future<Either<ErrorResModel, GetAllReviewSuggestionResModel>?>
      getAllReviews() async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.get(getAllReviewsURL);
      // log(response.data!);
      return Right(getAllReviewSuggestionResModelFromJson(response.data!));
    } on DioException catch (e) {
      return Left(errorResModelFromJson(e.response?.data));
    } catch (err) {
      return null;
    }
  }

  // GetAll Reviews for Merchants
  Future<Either<ErrorResModel, GetAllMerchantReviewsResModel>?>
      getAllMerchantReviews(int? id) async {
    try {
      Dio dio = await getClientNoToken();
      Response<String> response =
          await dio.get('$getAllMerchantReviewsURL?merchantId=$id');
      return Right(getAllMerchantReviewsResModelFromJson(response.data!));
    } on DioException catch (e) {
      return Left(errorResModelFromJson(e.response?.data));
    } catch (err) {
      return null;
    }
  }
}
