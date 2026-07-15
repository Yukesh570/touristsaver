import 'package:dio/dio.dart';
import 'package:touristsaver/constants/helper.dart';
import 'package:touristsaver/constants/url_end_point.dart';
import 'package:touristsaver/models/request/change_password_req.dart';
import 'package:touristsaver/models/response/change_password_res.dart';
import 'package:touristsaver/models/response/member_invitation_link_res.dart';
import 'package:touristsaver/models/response/user_detail_res.dart';

class DioMemberShip {
  Future<MemberInvitationLink> getMemberInvitationLink() async {
    final Dio dio = await getClient();
    final Response<dynamic> response = await dio.get(memberInvitationLink);
    return memberInvitationLinkFromResponse(response.data);
  }

  // Retrieving the user profile
  Future<UserProfileResModel?> getUserProfile() async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.get(oneMember);
      // log(response.data!);
      return userProfileResModelFromJson(response.data!);
    } catch (e) {
      return null;
    }
  }

  // Change Password
  Future<ChangePasswordResModel?> changePass(
      {required ChangePasswordReqModel changePasswordReqModel}) async {
    try {
      Dio dio = await getClient();
      Response<String> response = await dio.post(changePasswordUrl,
          data: changePasswordReqModel.toJson());
      return changePasswordResModelFromJson(response.data!);
    } catch (e) {
      return null;
    }
  }
}
