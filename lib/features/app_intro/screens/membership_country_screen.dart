import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:touristsaver/features/register/services/dio_register.dart';
import 'package:touristsaver/models/response/country_wise_prefix_res_model.dart';

class MembershipCountryScreen extends StatefulWidget {
  static const String routeName = '/membership-country';

  const MembershipCountryScreen({
    super.key,
    required this.registrationQueryParameters,
  });

  final Map<String, String> registrationQueryParameters;

  @override
  State<MembershipCountryScreen> createState() =>
      _MembershipCountryScreenState();
}

class _MembershipCountryScreenState extends State<MembershipCountryScreen> {
  static const Color _screenBackground = Color(0xFFF8FAFE);
  static const Color _headlineColor = Color(0xFF101B4D);
  static const Color _softText = Color(0xFF65708D);

  late final Future<CountryWisePrefixResModel?> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = DioRegister().countryOptions();
  }

  String _displayName(String? countryName) {
    return countryName == 'United States of America'
        ? 'USA'
        : countryName ?? '';
  }

  String _membershipStatus(Datum country) {
    return country.membershipStatus.trim().toLowerCase();
  }

  bool _isJoinable(Datum country) {
    return _membershipStatus(country) == 'available';
  }

  bool _isOpeningSoon(Datum country) {
    return _membershipStatus(country) == 'opening_soon';
  }

  String _flagEmoji(Datum country) {
    final code = country.countryShortName?.trim().toUpperCase() ?? '';
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return '🌏';
    return String.fromCharCodes(
      code.codeUnits.map((character) => character + 0x1F1A5),
    );
  }

  void _continueWithCountry(Datum country) {
    if (!_isJoinable(country) || country.id == null) return;

    context.goNamed(
      'register',
      queryParameters: {
        ...widget.registrationQueryParameters,
        'membershipCountryId': country.id.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBackground,
      body: SafeArea(
        child: FutureBuilder<CountryWisePrefixResModel?>(
          future: _countriesFuture,
          builder: (context, snapshot) {
            final countries = [...?snapshot.data?.data]..sort((a, b) =>
                _displayName(a.countryName)
                    .toLowerCase()
                    .compareTo(_displayName(b.countryName).toLowerCase()));
            final availableCountries =
                countries.where(_isJoinable).toList(growable: false);
            final openingSoonCountries =
                countries.where(_isOpeningSoon).toList(growable: false);

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.goNamed('intro-screen'),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: _headlineColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Where would you like to explore and save?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _headlineColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Choose the country for your TouristSaver membership.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _softText,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 26.h),
                  if (!snapshot.hasData)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    for (final country in availableCountries)
                      _CountryTile(
                        flag: _flagEmoji(country),
                        name: _displayName(country.countryName),
                        statusText: 'Select',
                        enabled: true,
                        onTap: () => _continueWithCountry(country),
                      ),
                    if (openingSoonCountries.isNotEmpty) ...[
                      SizedBox(height: 18.h),
                      Text(
                        'Opening soon',
                        style: TextStyle(
                          color: _headlineColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      for (final country in openingSoonCountries)
                        _CountryTile(
                          flag: _flagEmoji(country),
                          name: _displayName(country.countryName),
                          statusText: 'Opening soon',
                          enabled: false,
                          onTap: null,
                        ),
                    ],
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    required this.flag,
    required this.name,
    required this.statusText,
    required this.enabled,
    required this.onTap,
  });

  final String flag;
  final String name;
  final String statusText;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0009FE);
    const headlineColor = Color(0xFF101B4D);
    const softText = Color(0xFF65708D);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: enabled ? const Color(0xFFF3F6FF) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        elevation: enabled ? 1.5 : 0,
        shadowColor: primaryBlue.withValues(alpha: 0.18),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: enabled
                    ? primaryBlue.withValues(alpha: 0.62)
                    : const Color(0xFFE1E6F0),
                width: enabled ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(flag, style: TextStyle(fontSize: 22.sp)),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoSizeText(
                    name,
                    maxLines: 1,
                    style: TextStyle(
                      color: enabled ? headlineColor : softText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  statusText,
                  style: TextStyle(
                    color: enabled ? primaryBlue : softText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (enabled) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: primaryBlue,
                    size: 22.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
