import 'package:sms_autofill/sms_autofill.dart';

//To get the app Signature at first for sending to backend
String? getAsign;
getAppSign() async {
  getAsign = await SmsAutoFill().getAppSignature;
}
