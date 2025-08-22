// import 'dart:math';

// extension TruncateDoubles on double {
//   double truncateToDecimalPlaces(int fractionalDigits) =>
//       (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
// }

String toFixed2DecimalPlaces(double data, {int decimalPlaces = 2}) {
  // print('data');
  // print(data);
  List<String> values = data.toString().split('.');
  // print('values');
  // print(values);
  if (values.length == 2 &&
      // values[0] != '0' &&
      values[1].length >= decimalPlaces &&
      decimalPlaces > 0) {
    // print('first');
    return '${values[0]}.${values[1].substring(0, decimalPlaces)}';
  } else {
    // print('second');
    return data.toString();
  }
}
