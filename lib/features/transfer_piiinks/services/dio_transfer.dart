import 'package:dio/dio.dart';
import 'package:new_piiink/constants/helper.dart';
import 'package:new_piiink/constants/url_end_point.dart';
import 'package:new_piiink/models/request/tranfer_piiink_req.dart';
import 'package:new_piiink/models/response/tranfer_piiink_res.dart';

import '../../../models/request/transfer_piiinks_req_model.dart';

class DioTransfer {
  // Future<TransferPiiinkResModel?> tansferPiiink(
  Future<dynamic> tansferPiiink(
      {required TransferPiiinkReqModel transferPiiinkReqModel}) async {
    try {
      Dio dio = await getClient();
      Response<String> response =
          await dio.post(piiinkTransfer, data: transferPiiinkReqModel.toJson());
      return transferPiiinkResModelFromJson(response.data!);
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 400) {
          return e.response!.statusCode;
        } else {
          return null;
        }
      } else {
        // print("Error in transferring piiink: $e");
        return null;
      }
    }
  }

  // Future<TransferPiiinkResModel?> tansferPiiink(
  Future<dynamic> tansferPiiinksQR(
      {required TransferPiiinksReqModel transferPiiinksReqModel}) async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.post(piinksTransferQR,
          data: transferPiiinksReqModel.toJson());
      return transferPiiinkResModelFromJson(response.data!);
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 400) {
          return e.response!.statusCode;
        } else {
          return null;
        }
      } else {
        // print("Error in transferring piiink: $e");
        return null;
      }
    }
  }
}
