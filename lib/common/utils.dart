import 'package:intl/intl.dart';

String convertToLocalDateTime(DateTime utcDateTime) {
  DateTime dateTime =
      DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(utcDateTime.toString(), true);
  DateTime localDateTime = dateTime.toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd   hh:mm a');
  final String formatted = formatter.format(localDateTime);
  return formatted;
}

String getLastThreeMonthsRange({bool forApiCall = true}) {
  DateTime lastDate =
      forApiCall ? DateTime.now().add(const Duration(days: 1)) : DateTime.now();
  DateTime threeMonthsAgo = lastDate.subtract(const Duration(days: 90));
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  String startDate = dateFormat.format(threeMonthsAgo);
  String endDate = dateFormat.format(lastDate);
  return '$startDate:$endDate';
}

String interpolate(String string, {required List<dynamic> params}) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('{$i}', params[i].toString());
  }
  return result;
}

extension StringFormating on String {
  format({required List<dynamic> params}) {
    return interpolate(this, params: params);
  }
}

String prefixHttp(String url) {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'http://$url';
  }
  return url;
}
