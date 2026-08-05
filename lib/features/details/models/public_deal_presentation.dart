class PublicDealOpeningHoursRow {
  const PublicDealOpeningHoursRow({required this.weekday, required this.value});

  final String weekday;
  final String value;
}

const List<String> publicDealWeekdays = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const Set<String> _missingPhoneSentinels = <String>{
  'n/a',
  'na',
  'none',
  'null',
  'unknown',
  'not available',
  'not provided',
  'not published',
  'unavailable',
  'tbc',
  'tbd',
  '-',
  '--',
};

bool usesPublicDealPresentation(String? listingType) =>
    listingType?.trim().toLowerCase() == 'public_deal';

String? usablePublicDealPhone(String? value) {
  final String? trimmed = value?.trim();
  if (trimmed == null ||
      trimmed.isEmpty ||
      _missingPhoneSentinels.contains(trimmed.toLowerCase())) {
    return null;
  }
  final String digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty ||
      RegExp(r'^0+$').hasMatch(digits) ||
      digits.length < 7 ||
      digits.length > 15) {
    return null;
  }
  return trimmed;
}

List<PublicDealOpeningHoursRow> parsePublicDealOpeningHours(String? rawHours) {
  final Map<String, String> values = <String, String>{};
  for (final String part in (rawHours ?? '').split(RegExp(r'[\n;]'))) {
    final String line = part.trim();
    final int separator = line.indexOf(':');
    if (separator <= 0) continue;
    final String suppliedDay =
        line.substring(0, separator).trim().toLowerCase();
    for (final String weekday in publicDealWeekdays) {
      if (suppliedDay == weekday.toLowerCase() ||
          suppliedDay == weekday.substring(0, 3).toLowerCase()) {
        values[weekday] = line.substring(separator + 1).trim();
        break;
      }
    }
  }
  return publicDealWeekdays
      .map((String weekday) => PublicDealOpeningHoursRow(
            weekday: weekday,
            value: values[weekday]?.isNotEmpty == true
                ? values[weekday]!
                : 'Not published',
          ))
      .toList(growable: false);
}

PublicDealOpeningHoursRow publicDealHoursForWeekday(
  String? rawHours,
  int weekday,
) {
  final int safeIndex = weekday >= DateTime.monday && weekday <= DateTime.sunday
      ? weekday - DateTime.monday
      : 0;
  return parsePublicDealOpeningHours(rawHours)[safeIndex];
}
