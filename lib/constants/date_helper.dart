import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}

String timeAgoCustom(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  DateFormat dateFormatWeek = DateFormat('EEEE');
  if (diff.inDays > 365) {
    return "${dateFormatWeek.format(d)}, ${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "{}year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${dateFormatWeek.format(d)}, ${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${dateFormatWeek.format(d)}, ${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  // if (diff.inDays == 0) {
  //   return 'Today';
  // }
  // if (diff.inDays == 1) {
  //   return 'Yesterday';
  // }
  if (diff.inDays > 0) {
    // return DateFormat.E().add_jm().format(d); //Example: Thu 10:31 AM
    return dateFormatWeek.format(d); //Example: Sunday, Monday
  }

  // if (diff.inHours > 0) {
  //   return "Today ${DateFormat('jm').format(d)}"; //Example: 12:00 AM
  // }
  // if (diff.inMinutes > 0) {
  //   return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  // }
  return "just now";
}
