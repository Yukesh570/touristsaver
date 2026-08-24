import 'dart:async';
// import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:touristsaver/common/models/registration_code_resolution.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';
import 'package:touristsaver/common/widgets/custom_button.dart';
import 'package:touristsaver/common/widgets/custom_loader.dart';
import 'package:touristsaver/common/widgets/custom_snackbar.dart';
import 'package:touristsaver/common/widgets/error.dart';
import 'package:touristsaver/constants/global_colors.dart';
import 'package:touristsaver/constants/read_sms_otp.dart';
import 'package:touristsaver/constants/style.dart';
import 'package:touristsaver/features/connectivity/cubit/internet_cubit.dart';
import 'package:touristsaver/features/location/bloc/location_all_blocs.dart';
import 'package:touristsaver/features/location/bloc/location_all_events.dart';
import 'package:touristsaver/features/location/bloc/location_all_states.dart';
import 'package:touristsaver/features/location/services/dio_location.dart';
import 'package:touristsaver/features/register/services/dio_register.dart';
import 'package:touristsaver/models/request/phone_otp_req.dart';
import 'package:touristsaver/models/request/premium_validity_req.dart';
import 'package:touristsaver/models/request/reg_member_otp_req.dart';
import 'package:touristsaver/models/response/check_issuer_res.dart';
import 'package:touristsaver/models/response/common_res.dart';
import 'package:touristsaver/models/response/get_app_slugs_res_model.dart';
import 'package:touristsaver/models/response/location_get_all.dart';
import 'package:touristsaver/models/response/nearby_charity_res.dart';
import 'package:touristsaver/models/response/residence_country_res_model.dart';

import '../../../common/app_variables.dart';
import '../../../common/widgets/dropdown_button_widget.dart';
import '../../../models/request/nearby_req.dart';
import '../../../models/response/country_wise_prefix_res_model.dart';
import '../../charity/services/dio_charity.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../connectivity/screens/connectivity_screen.dart';
import '../../profile/widget/info_popup.dart';
import 'package:touristsaver/generated/l10n.dart';

bool isRegistrationPhoneStructurallyValid({
  required String? phonePrefix,
  required String phoneNumber,
}) =>
    phonePrefix?.trim().isNotEmpty == true && phoneNumber.trim().length >= 7;

bool shouldShowRegistrationPromoCodePanel({
  required bool recognizedDiscoveryInvitation,
  required RegistrationCodeResolution? resolution,
  required bool validationFailed,
}) =>
    validationFailed ||
    (!recognizedDiscoveryInvitation && resolution?.isDiscovery != true);

const String unavailableInvitationRecoveryMessage =
    'That invitation is no longer available, but your registration details are safe. You can continue without it or enter another promo or invitation code below.';

bool shouldRecoverUnavailableInvitationOnRegistrationForm(String path) =>
    path == RegisterScreen.routeName;

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  final String? issuercode;
  final String? memberReferralCode;
  final String? memberPremiumCode;
  final String? discoveryInvitationCode;
  final String? registrationCode;
  final bool discoveryInvitationRecognized;
  final int? membershipCountryId;
  final bool membershipCountryLocked;

  const RegisterScreen({
    super.key,
    this.issuercode,
    this.memberReferralCode,
    this.memberPremiumCode,
    this.discoveryInvitationCode,
    this.registrationCode,
    this.discoveryInvitationRecognized = false,
    this.membershipCountryId,
    this.membershipCountryLocked = false,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController charitySearchController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassowrdController =
      TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController residentialPostalCodeController =
      TextEditingController();
  final TextEditingController premiumController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  final TextEditingController phonePrefixSearchController =
      TextEditingController();
  final TextEditingController residenceCountrySearchController =
      TextEditingController();

  late final LocationAllBloc _locationAllBloc;
  bool _locationBlocReady = false;

  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // For check box
  bool isChecked = false;

  // For seeing password
  bool _isHidden = true;
  bool _isHidden1 = true;

  bool _isPromoExpanded = false;
  String? _currentRegistrationCode;
  RegistrationCodeResolution? _currentRegistrationCodeResolution;
  bool _registrationCodeValidationFailed = false;
  bool _showUnavailableInvitationInfo = false;
  late bool _linkedDiscoveryInvitationRecognized;
  StreamSubscription<void>? _unavailableInvitationSubscription;

  bool get _hasRecognizedDiscoveryInvitation =>
      !shouldShowRegistrationPromoCodePanel(
        recognizedDiscoveryInvitation: _linkedDiscoveryInvitationRecognized,
        resolution: _currentRegistrationCodeResolution,
        validationFailed: _registrationCodeValidationFailed,
      );

  static const Color _primaryBlue = Color(0xFF0009FE);
  static const Color _ctaCyan = Color(0xFF18C6FF);
  static const Color _fieldBorder = Color(0xFFD8DEEC);
  static const Color _softText = Color(0xFF65708D);
  static const double _inputHeight = 55;

  // For dropDown of selecting country
  String? selectedCountry;
  int? selectedCountryID;
  int? selectedResidenceCountryID;
  String? selectedResidenceCountryName;
  String? selectedResidenceCountryIso3;
  bool selectedResidenceUsesPostalCode = false;
  bool selectedResidencePostalCodeRequired = false;
  String? selectedResidencePostalCodeLabel;
  int? selectedResidencePostalCodeMaxLength;
  int? selectedStateID;
  String? selectedPhonePrefix;
  String? selectedPhonePrefixKey;
  String? selectedCharity;
  int? selectedCharityID;
  String? slugg;
  String? infoTitile;
  String? infoMessage;
  bool isSlugLoading = false;
  bool isSlugLoading1 = false;
  bool firstNameAutoCapitalisedOnce = false;
  bool lastNameAutoCapitalisedOnce = false;
  bool _isAutoCapitalisingName = false;
  String _previousFirstNameText = '';
  String _previousLastNameText = '';

  Future<CountryWisePrefixResModel?>? phonePrefixList;
  Future<ResidenceCountryResModel?>? residenceCountryOptionsList;
  Future<CountryWisePrefixResModel?> getPhonePrefix() async {
    CountryWisePrefixResModel? countryWisePrefixResModel =
        await DioRegister().countryPhonePrefix();
    return countryWisePrefixResModel;
  }

//Calling API of GetAll Charity
  Future<NearByCharityListResModel?>? nearByCharityForReg;
  Future<NearByCharityListResModel?>? getNearByCharityForReg(
      int countryId) async {
    NearByCharityListResModel? nearByCharityListResModel =
        await DioCharity().getNearByCharity(
      nearByLocationReqModel: NearByLocationReqModel(
        countryId: countryId,
        latitude: AppVariables.latitude,
        longitude: AppVariables.longitude,
        radius: 50,
        lang: AppVariables.selectedLanguageNow,
      ),
    );
    return nearByCharityListResModel;
  }

  Future<void> getAppSlugs(String? slugg) async {
    setState(() {
      if (slugg == 'referral-code') {
        isSlugLoading1 = true;
      } else if (slugg == 'issuer-code') {
        isSlugLoading = true;
      }
    });
    GetAppSlugResModel? getAppSlugResModel =
        await DioRegister().getAppSlugMessages(slugg);
    infoTitile = getAppSlugResModel!.data!.slug;
    infoMessage = getAppSlugResModel.data!.information;
    setState(() {
      isSlugLoading = false;
      isSlugLoading1 = false;
    });
  }

  //For checking the phone number is valid with its country code or not
  String? selectedCountryShortName;

  //Flutter BarCode Scanner for Provider Info
  providerScanResult(String value) async {
    // await FlutterBarcodeScanner.scanBarcode(
    //         '#EC4785', 'Cancel', true, ScanMode.QR)
    //     .then((value) {
    if (value.contains('https://')) {
      var uri = Uri.parse(value.toString());
      if (uri.queryParameters['issuercode'] != null) {
        providerController.text = uri.queryParameters['issuercode'].toString();
      } else {
        providerController.text = value == '-1' ? '' : value;
      }
    } else {
      providerController.text = value == '-1' ? '' : value;
    }
    if (mounted) setState(() {});
    // });
  }

  //Flutter BarCode Scanner for Member Referral Code
  referralCodeScanResult(String value) async {
    // await FlutterBarcodeScanner.scanBarcode(
    //         '#EC4785', 'Cancel', true, ScanMode.QR)
    //     .then((value) {
    if (value.contains('https://')) {
      var uri = Uri.parse(value.toString());
      if (uri.queryParameters['memberReferralCode'] != null) {
        referralCodeController.text =
            uri.queryParameters['memberReferralCode'].toString();
      } else {
        referralCodeController.text = value == '-1' ? '' : value;
      }
    } else {
      referralCodeController.text = value == '-1' ? '' : value;
    }
    if (mounted) setState(() {});
    // });
  }

  // For the Loading part
  var isLoading = false;

  @override
  void initState() {
    _linkedDiscoveryInvitationRecognized = widget.discoveryInvitationRecognized;
    firstNameController.addListener(_handleFirstNameChanged);
    lastNameController.addListener(_handleLastNameChanged);
    _unavailableInvitationSubscription = BranchReferralService
        .unavailableInvitationLinks
        .listen((_) => _consumeUnavailableInvitationNotice());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      phonePrefixList = getPhonePrefix();
      residenceCountryOptionsList = DioRegister().residenceCountries();
      // allCharityy = getAllCharityy();
      providerController.text = widget.issuercode ?? '';
      referralCodeController.text = widget.memberReferralCode ?? '';
      premiumController.text = widget.memberPremiumCode ?? '';
      _currentRegistrationCode = _nonEmptyCode(widget.registrationCode) ??
          _nonEmptyCode(widget.discoveryInvitationCode);
      _consumeUnavailableInvitationNotice();
      setState(() {});
    });
    super.initState();
  }

  String? _nonEmptyCode(String? value) {
    final code = value?.trim() ?? '';
    return code.isEmpty || code.toLowerCase() == 'null' ? null : code;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locationBlocReady) return;

    _locationAllBloc =
        LocationAllBloc(RepositoryProvider.of<DioLocation>(context))
          ..add(LoadLocationAllEvent());
    _locationBlocReady = true;
  }

  dialogInfo(String infoText) {
    return showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: true, //to dismiss the container once opened
      barrierColor: Colors.black.withValues(
          alpha:
              0.5), //to change the background color once the container is opened
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: InfoPopUp1(
            body: infoMessage ?? '',
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _unavailableInvitationSubscription?.cancel();
    _locationAllBloc.close();
    firstNameController.removeListener(_handleFirstNameChanged);
    lastNameController.removeListener(_handleLastNameChanged);
    charitySearchController.dispose();
    providerController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassowrdController.dispose();
    mobileNumberController.dispose();
    residentialPostalCodeController.dispose();
    premiumController.dispose();
    referralCodeController.dispose();
    phonePrefixSearchController.dispose();
    residenceCountrySearchController.dispose();
    super.dispose();
  }

  void _consumeUnavailableInvitationNotice() {
    if (!mounted ||
        !BranchReferralService.takePendingUnavailableInvitationNotice()) {
      return;
    }
    _recoverFromUnavailableLinkedInvitation();
  }

  void _recoverFromUnavailableLinkedInvitation() {
    setState(() {
      isLoading = false;
      _linkedDiscoveryInvitationRecognized = false;
      _currentRegistrationCode = null;
      _currentRegistrationCodeResolution = null;
      _registrationCodeValidationFailed = false;
      _showUnavailableInvitationInfo = true;
      _isPromoExpanded = true;
    });
  }

  Widget _unavailableInvitationInfo() {
    return Container(
      key: const Key('unavailable-invitation-recovery-info'),
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF0D38A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFF9A6700),
            size: 21.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              unavailableInvitationRecoveryMessage,
              style: TextStyle(
                color: const Color(0xFF5A4A12),
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appliedAttributionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7FF),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE1E9FA)),
          ),
          child: AutoSizeText(
            text,
            style: TextStyle(
              color: _softText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _registrationHeader(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = screenHeight * 0.32;

    return SizedBox(
      height: headerHeight.clamp(230.0, 310.0).toDouble(),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/onboarding/header_au.webp',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 12.h,
              left: 16.w,
              child: Material(
                color: Colors.white.withValues(alpha: 0.9),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.goNamed('intro-screen'),
                  child: Padding(
                    padding: EdgeInsets.all(9.w),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF0D1A4A),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Icon(icon, color: _primaryBlue, size: 22.sp),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _modernInputDecoration({
    required String hintText,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: _softText.withValues(alpha: 0.82),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: icon == null ? null : Icon(icon, color: _softText, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _fieldBorder),
      ),
    );
  }

  TextStyle get _dropdownHintStyle => TextStyle(
        color: _softText.withValues(alpha: 0.82),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  Widget _placeholderField(String text) {
    return Container(
      width: double.infinity,
      height: _inputHeight,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _fieldBorder),
      ),
      child: AutoSizeText(
        text,
        style: TextStyle(
          color: _softText.withValues(alpha: 0.82),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _promoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            setState(() {
              _isPromoExpanded = !_isPromoExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE4ECFB)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32.w,
                  child: Icon(
                    Icons.sell_outlined,
                    color: _primaryBlue,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Have a promo or invitation code?',
                        style: TextStyle(
                          color: const Color(0xFF101B4D),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'We’ll verify your code before you continue.',
                          maxLines: 1,
                          style: TextStyle(
                            color: _softText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isPromoExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: _primaryBlue,
                ),
              ],
            ),
          ),
        ),
        if (_isPromoExpanded) ...[
          SizedBox(height: 12.h),
          TextFormField(
            controller: premiumController,
            cursorColor: _primaryBlue,
            decoration: _modernInputDecoration(
              hintText: S.of(context).preCode,
              icon: Icons.sell_outlined,
            ),
          ),
        ],
      ],
    );
  }

  String _countryDisplayName(Object? countryName) {
    final String name = countryName?.toString() ?? '';
    return name == 'United States of America' ? 'USA' : name;
  }

  String? _countryCodeForFlag(Object? countryName) {
    switch (countryName?.toString()) {
      case 'Australia':
        return 'AU';
      case 'Canada':
        return 'CA';
      case 'China':
        return 'CN';
      case 'Fiji':
        return 'FJ';
      case 'Germany':
        return 'DE';
      case 'India':
        return 'IN';
      case 'Indonesia':
        return 'ID';
      case 'Ireland':
        return 'IE';
      case 'Lao':
        return 'LA';
      case 'Malaysia':
        return 'MY';
      case 'New Zealand':
        return 'NZ';
      case 'Philippines':
        return 'PH';
      case 'Singapore':
        return 'SG';
      case 'South Africa':
        return 'ZA';
      case 'Thailand':
        return 'TH';
      case 'United Kingdom':
        return 'GB';
      case 'United States of America':
        return 'US';
      case 'Vietnam':
        return 'VN';
    }
    return null;
  }

  String? _flagEmoji(Object? countryName) {
    final String? countryCode = _countryCodeForFlag(countryName);
    if (countryCode == null || countryCode.length != 2) return null;

    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([firstLetter, secondLetter]);
  }

  String _flagEmojiFromAlpha2(String isoAlpha2) {
    final code = isoAlpha2.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return '🌏';
    return String.fromCharCodes(
      code.codeUnits.map((character) => character + 0x1F1A5),
    );
  }

  void _selectResidenceCountry(ResidenceCountry country) {
    selectedResidenceCountryID = country.id;
    selectedResidenceCountryName = country.countryName;
    selectedResidenceCountryIso3 = country.isoAlpha3;
    selectedResidenceUsesPostalCode = country.collectResidentialPostalCode;
    selectedResidencePostalCodeRequired = country.residentialPostalCodeRequired;
    selectedResidencePostalCodeLabel =
        country.residentialPostalCodeLabel?.trim().isNotEmpty == true
            ? country.residentialPostalCodeLabel!.trim()
            : null;
    selectedResidencePostalCodeMaxLength =
        country.residentialPostalCodeMaxLength;
    if (!selectedResidenceUsesPostalCode) {
      residentialPostalCodeController.clear();
    }
  }

  String _residenceDropdownKey(ResidenceCountry item, int index) {
    return '${item.countryName} ${item.isoAlpha3} ${item.id}';
  }

  String? _selectedResidenceKey(List<ResidenceCountry> countryItems) {
    if (selectedResidenceCountryID == null) return null;
    final int index = countryItems
        .indexWhere((item) => item.id == selectedResidenceCountryID);
    return index < 0 ? null : _residenceDropdownKey(countryItems[index], index);
  }

  Widget _fallbackFlag(Object? countryName) {
    final String? emoji = _flagEmoji(countryName);
    if (emoji != null) {
      return Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 17.sp),
        ),
      );
    }

    return Container(
      color: const Color(0xFFEAF0F8),
      alignment: Alignment.center,
      child: Icon(
        Icons.flag_outlined,
        color: _softText,
        size: 15.sp,
      ),
    );
  }

  Widget _prefixFlag(Object? logoUrl, Object? countryName) {
    final String flagUrl = logoUrl?.toString().trim() ?? '';
    if (flagUrl.isEmpty) return _fallbackFlag(countryName);

    final String imageUrl = flagUrl;
    final bool isSvg = imageUrl.toLowerCase().contains('.svg');

    if (isSvg) {
      return SvgPicture.network(
        imageUrl,
        height: 20,
        width: 25,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _fallbackFlag(countryName),
        errorBuilder: (_, __, ___) => _fallbackFlag(countryName),
      );
    }

    return Image.network(
      imageUrl,
      height: 20,
      width: 25,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _fallbackFlag(countryName);
      },
    );
  }

  String _prefixDropdownKey(dynamic item, int index) {
    final String countryName = item.countryName?.toString() ?? '';
    final String displayName = _countryDisplayName(countryName);
    final String phonePrefix = item.phonePrefix?.toString() ?? '';
    final String id = item.id?.toString() ?? index.toString();
    return '$displayName $countryName $phonePrefix $id';
  }

  String? _selectedPrefixKey(List<dynamic> prefixItems) {
    if (selectedPhonePrefix == null) return null;

    for (var index = 0; index < prefixItems.length; index++) {
      if (_prefixDropdownKey(prefixItems[index], index) ==
          selectedPhonePrefixKey) {
        return selectedPhonePrefixKey;
      }
    }

    final int countryMatchIndex = prefixItems.indexWhere((item) =>
        item.phonePrefix?.toString() == selectedPhonePrefix &&
        item.countryName?.toString() == selectedCountry);
    if (countryMatchIndex >= 0) {
      return _prefixDropdownKey(
          prefixItems[countryMatchIndex], countryMatchIndex);
    }

    final int prefixMatchIndex = prefixItems.indexWhere(
        (item) => item.phonePrefix?.toString() == selectedPhonePrefix);
    if (prefixMatchIndex >= 0) {
      return _prefixDropdownKey(
          prefixItems[prefixMatchIndex], prefixMatchIndex);
    }

    return null;
  }

  Widget _phoneNumberFields() {
    final double prefixWidth = (MediaQuery.of(context).size.width * 0.32)
        .clamp(118.0, 145.0)
        .toDouble();
    const double prefixFieldHeight = _inputHeight - 2;

    return FutureBuilder<CountryWisePrefixResModel?>(
        future: phonePrefixList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Error1();
          } else if (!snapshot.hasData) {
            return Row(
              children: [
                SizedBox(
                  width: prefixWidth,
                  child: AutoSizeText(
                    S.of(context).pleaseWaitD,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: GlobalColors.gray.withValues(alpha: 0.8),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: AutoSizeText(
                    S.of(context).pleaseWaitD,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: GlobalColors.gray.withValues(alpha: 0.8),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          } else {
            final prefixItems = [...snapshot.data!.data!]..sort((a, b) =>
                (a.countryName ?? '')
                    .toString()
                    .toLowerCase()
                    .compareTo((b.countryName ?? '').toString().toLowerCase()));
            final prefixItemsByKey = <String, dynamic>{
              for (var index = 0; index < prefixItems.length; index++)
                _prefixDropdownKey(prefixItems[index], index):
                    prefixItems[index],
            };

            return Row(
              children: [
                SizedBox(
                  width: prefixWidth,
                  height: prefixFieldHeight,
                  child: DropdownButtonWidget(
                    label: S.of(context).prefix,
                    bWidth: prefixWidth,
                    dropWidth: 190.w,
                    lPadding: 3,
                    fillColor: Colors.white,
                    borderColor: _fieldBorder,
                    borderRadius: 12.r,
                    iconColor: _primaryBlue,
                    hintStyle: _dropdownHintStyle,
                    height: prefixFieldHeight,
                    buttonHeight: prefixFieldHeight - 2,
                    buttonPadding: EdgeInsets.only(left: 10.w, right: 0),
                    searchController: phonePrefixSearchController,
                    items: prefixItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final e = entry.value;
                      return DropdownMenuItem(
                        value: _prefixDropdownKey(e, index),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey
                                            .withValues(alpha: 0.4))),
                                clipBehavior: Clip.antiAlias,
                                child: _prefixFlag(e.logoUrl, e.countryName),
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                child: AutoSizeText(
                                  '${_countryDisplayName(e.countryName)} ${e.phonePrefix ?? ''}',
                                  maxLines: 1,
                                  style: dopdownTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) {
                      return prefixItems.map((e) {
                        return Row(
                          children: [
                            Container(
                              height: 20,
                              width: 25,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Colors.grey.withValues(alpha: 0.4))),
                              clipBehavior: Clip.antiAlias,
                              child: _prefixFlag(e.logoUrl, e.countryName),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: AutoSizeText(
                                e.phonePrefix ?? '',
                                maxLines: 1,
                                style: dopdownTextStyle,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                    onChanged: (newVal) async {
                      final String key = newVal as String;
                      final selectedPrefixItem = prefixItemsByKey[key];
                      setState(() {
                        selectedPhonePrefix =
                            selectedPrefixItem?.phonePrefix?.toString();
                        selectedPhonePrefixKey = key;
                        phonePrefixSearchController.clear();
                      });
                    },
                    value: _selectedPrefixKey(prefixItems),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: SizedBox(
                    height: _inputHeight,
                    child: TextFormField(
                      controller: mobileNumberController,
                      cursorColor: _primaryBlue,
                      decoration: _modernInputDecoration(
                        hintText: 'Mobile number',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]*'))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget _residenceFields() {
    return FutureBuilder<ResidenceCountryResModel?>(
      future: residenceCountryOptionsList,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _placeholderField(S.of(context).pleaseWaitD);
        }

        final countryItems = snapshot.data!.data.toList(growable: false)
          ..sort((a, b) => a.countryName
              .toLowerCase()
              .compareTo(b.countryName.toLowerCase()));
        final countryItemsByKey = <String, ResidenceCountry>{
          for (var index = 0; index < countryItems.length; index++)
            _residenceDropdownKey(countryItems[index], index):
                countryItems[index],
        };

        final String postcodeLabel =
            selectedResidencePostalCodeLabel ?? 'Postcode';
        final int postcodeMaxLength =
            selectedResidencePostalCodeMaxLength ?? 32;

        return Row(
          children: [
            Expanded(
              flex: selectedResidenceUsesPostalCode ? 5 : 10,
              child: SizedBox(
                height: _inputHeight,
                child: DropdownButtonWidget(
                  label: 'Country of Residence *',
                  bWidth: double.infinity,
                  dropWidth: 245.w,
                  fillColor: Colors.white,
                  borderColor: _fieldBorder,
                  borderRadius: 12.r,
                  iconColor: _primaryBlue,
                  hintStyle: _dropdownHintStyle,
                  searchController: residenceCountrySearchController,
                  items: countryItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final e = entry.value;
                    return DropdownMenuItem(
                      value: _residenceDropdownKey(e, index),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30.w,
                            child: Text(
                              _flagEmojiFromAlpha2(e.isoAlpha2),
                              style: TextStyle(fontSize: 17.sp),
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              e.countryName,
                              maxLines: 1,
                              style: dopdownTextStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return countryItems.map((e) {
                      return Row(
                        children: [
                          Text(
                            _flagEmojiFromAlpha2(e.isoAlpha2),
                            style: TextStyle(fontSize: 17.sp),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: AutoSizeText(
                              e.countryName,
                              maxLines: 1,
                              style: dopdownTextStyle,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  onChanged: (newVal) {
                    final selectedItem = countryItemsByKey[newVal as String];
                    if (selectedItem == null) return;
                    setState(() {
                      _selectResidenceCountry(selectedItem);
                      residenceCountrySearchController.clear();
                    });
                  },
                  value: _selectedResidenceKey(countryItems),
                ),
              ),
            ),
            if (selectedResidenceUsesPostalCode) ...[
              const SizedBox(width: 10.0),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: _inputHeight,
                  child: TextFormField(
                    controller: residentialPostalCodeController,
                    cursorColor: _primaryBlue,
                    decoration: _modernInputDecoration(
                      hintText: postcodeLabel,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(postcodeMaxLength),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9 -]'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  bool _applyMembershipCountryDefaults(LocationGetAllResModel locations) {
    final int? requestedMembershipCountryId = widget.membershipCountryId;
    for (final country in locations.data ?? const []) {
      final code = country.countryShortName?.trim().toUpperCase();
      final name = country.countryName?.trim().toLowerCase();
      final bool matchesRequestedCountry = requestedMembershipCountryId != null
          ? country.id == requestedMembershipCountryId
          : code == 'AU' || code == 'AUS' || name == 'australia';
      if (matchesRequestedCountry) {
        selectedCountry = country.countryName ?? 'Australia';
        selectedCountryID = country.id;
        selectedCountryShortName = country.countryShortName ?? 'AU';
        return selectedCountryID != null;
      }
    }
    return false;
  }

  Future<bool> _loadMembershipCountryBackendDefaults() async {
    final countryId = selectedCountryID;
    if (countryId == null) return false;
    if (selectedStateID != null) return true;

    final states = await DioLocation().getAllState(countryID: countryId);
    final availableStates = states?.data ?? const [];
    if (availableStates.isEmpty) return false;

    final queensland = availableStates.where((state) {
      final name = state.stateName?.trim().toLowerCase();
      final code = state.stateShortName?.trim().toUpperCase();
      return name == 'queensland' || code == 'QLD';
    });
    selectedStateID =
        (queensland.isNotEmpty ? queensland.first : availableStates.first).id;
    return selectedStateID != null;
  }

  Widget _gradientContinueButton() {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [_primaryBlue, _ctaCyan],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: isLoading ? null : _submitRegistration,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _submitRegistration() async {
    setState(() {
      isLoading = true;
    });

    if (selectedCountryID == null) {
      GlobalSnackBar.showError(
          context, 'Membership country is unavailable right now.');
      setState(() {
        isLoading = false;
      });
      return;
    } else if (firstNameController.text.isEmpty) {
      GlobalSnackBar.valid(context, S.of(context).pleaseFillFirstName);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (lastNameController.text.isEmpty) {
      GlobalSnackBar.valid(context, S.of(context).pleaseFillLastName);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (!reg.hasMatch(emailController.text) ||
        emailController.text.isEmpty) {
      GlobalSnackBar.valid(context, S.of(context).pleaseFillTheCorrectEmail);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (passwordController.text.isEmpty) {
      GlobalSnackBar.valid(context, S.of(context).pleaseFillThePassword);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (confirmPassowrdController.text.isEmpty) {
      GlobalSnackBar.valid(context, S.of(context).pleaseFillConfirmPassword);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (confirmPassowrdController.text !=
        passwordController.text.trim()) {
      GlobalSnackBar.valid(context, S.of(context).confirmPasswordDoesNotMatch);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (!isRegistrationPhoneStructurallyValid(
      phonePrefix: selectedPhonePrefix,
      phoneNumber: mobileNumberController.text,
    )) {
      final String message = selectedPhonePrefix?.trim().isNotEmpty != true
          ? S.of(context).pleaseSelectPhonePrefix
          : mobileNumberController.text.isEmpty
              ? S.of(context).pleaseFillCorrectMobileNumber
              : S.of(context).phoneNumberShouldBeAtLeast7Digits;
      GlobalSnackBar.valid(context, message);
      setState(() {
        isLoading = false;
      });
      return;
    } else if (selectedResidenceCountryID == null) {
      GlobalSnackBar.valid(context, 'Please select your residence country.');
      setState(() {
        isLoading = false;
      });
      return;
    } else if (selectedResidenceUsesPostalCode &&
        selectedResidencePostalCodeRequired &&
        residentialPostalCodeController.text.trim().isEmpty) {
      GlobalSnackBar.valid(
        context,
        'Please enter your ${selectedResidencePostalCodeLabel ?? 'postcode'}.',
      );
      setState(() {
        isLoading = false;
      });
      return;
    } else if (!selectedResidenceUsesPostalCode &&
        residentialPostalCodeController.text.trim().isNotEmpty) {
      GlobalSnackBar.valid(
        context,
        'Postal code is not required for your residence country.',
      );
      setState(() {
        isLoading = false;
      });
      return;
    } else if (isChecked == false) {
      GlobalSnackBar.valid(context, S.of(context).pleaseAcceptTermsConditions);
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      final defaultsReady = await _loadMembershipCountryBackendDefaults();
      if (!mounted) return;
      if (!defaultsReady) {
        GlobalSnackBar.showError(
          context,
          'Membership country details are unavailable. Please try again.',
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
      checkProvider();
    }
  }

  void _handleFirstNameChanged() {
    _handleNameChanged(
      controller: firstNameController,
      previousText: _previousFirstNameText,
      autoCapitalisedOnce: firstNameAutoCapitalisedOnce,
      updateState: ({
        required String previousText,
        required bool autoCapitalisedOnce,
      }) {
        _previousFirstNameText = previousText;
        firstNameAutoCapitalisedOnce = autoCapitalisedOnce;
      },
    );
  }

  void _handleLastNameChanged() {
    _handleNameChanged(
      controller: lastNameController,
      previousText: _previousLastNameText,
      autoCapitalisedOnce: lastNameAutoCapitalisedOnce,
      updateState: ({
        required String previousText,
        required bool autoCapitalisedOnce,
      }) {
        _previousLastNameText = previousText;
        lastNameAutoCapitalisedOnce = autoCapitalisedOnce;
      },
    );
  }

  void _handleNameChanged({
    required TextEditingController controller,
    required String previousText,
    required bool autoCapitalisedOnce,
    required void Function({
      required String previousText,
      required bool autoCapitalisedOnce,
    }) updateState,
  }) {
    if (_isAutoCapitalisingName) {
      updateState(
        previousText: controller.text,
        autoCapitalisedOnce: autoCapitalisedOnce,
      );
      return;
    }

    final String currentText = controller.text;
    if (currentText.isEmpty) {
      updateState(previousText: '', autoCapitalisedOnce: false);
      return;
    }

    if (previousText.isEmpty &&
        !autoCapitalisedOnce &&
        currentText.length == 1 &&
        currentText == currentText.toLowerCase() &&
        currentText != currentText.toUpperCase()) {
      final TextSelection selection = controller.selection;
      final String capitalised = currentText.toUpperCase();
      _isAutoCapitalisingName = true;
      controller.value = TextEditingValue(
        text: capitalised,
        selection: selection.copyWith(
          baseOffset: selection.baseOffset.clamp(0, capitalised.length),
          extentOffset: selection.extentOffset.clamp(0, capitalised.length),
        ),
        composing: TextRange.empty,
      );
      _isAutoCapitalisingName = false;
      updateState(previousText: capitalised, autoCapitalisedOnce: true);
      return;
    }

    updateState(
      previousText: currentText,
      autoCapitalisedOnce: autoCapitalisedOnce,
    );
  }

  @override
  Widget build(BuildContext context) {
    // List arr = S.of(context).iAgreeWithTheTermsAndCondition.split(" ");
    // List iagree = S.of(context).iAgreeWithTheTermsAndCondition.split("&");
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFE),
        body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, state) {
            if (state == ConnectivityState.loading) {
              return const NoInternetLoader();
            } else if (state == ConnectivityState.disconnected) {
              return const NoConnectivityScreen();
            } else if (state == ConnectivityState.connected) {
              return BlocProvider.value(
                value: _locationAllBloc,
                child: BlocBuilder<LocationAllBloc, LocationAllState>(
                  builder: (context, locationState) {
                    // Loading State
                    if (locationState is LocationAllLoadingState) {
                      return const Column(
                        children: [
                          CustomAllLoader(),
                        ],
                      );
                    }
                    // Loaded State
                    else if (locationState is LocationAllLoadedState) {
                      LocationGetAllResModel locationList =
                          locationState.locationGetAll; //Location
                      if (!_applyMembershipCountryDefaults(locationList)) {
                        return const Error1();
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: [
                            _registrationHeader(context),
                            Transform.translate(
                              offset: const Offset(0, -20),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                padding:
                                    EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _sectionHeader(
                                        Icons.person_outline, 'Your Details'),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: firstNameController,
                                            cursorColor: _primaryBlue,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: _modernInputDecoration(
                                              hintText: S.of(context).firstName,
                                              icon: Icons.person_outline,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: TextFormField(
                                            controller: lastNameController,
                                            cursorColor: _primaryBlue,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: _modernInputDecoration(
                                              hintText: S.of(context).lastName,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),

                                    _residenceFields(),
                                    const SizedBox(height: 15),

                                    // E-mail
                                    TextFormField(
                                      controller: emailController,
                                      cursorColor: _primaryBlue,
                                      decoration: _modernInputDecoration(
                                        hintText: S.of(context).email,
                                        icon: Icons.email_outlined,
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    _phoneNumberFields(),
                                    const SizedBox(height: 22),

                                    _sectionHeader(Icons.lock_outline,
                                        'Secure Your Account'),

                                    // Password
                                    TextFormField(
                                      controller: passwordController,
                                      cursorColor: _primaryBlue,
                                      decoration: _modernInputDecoration(
                                        hintText: S.of(context).passwordA,
                                        icon: Icons.lock_outline,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isHidden = !_isHidden;
                                            });
                                          },
                                          child: Icon(
                                            _isHidden
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: _softText,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      obscureText: _isHidden,
                                    ),

                                    const SizedBox(height: 15),

                                    // Confirm Password
                                    TextFormField(
                                      controller: confirmPassowrdController,
                                      cursorColor: _primaryBlue,
                                      decoration: _modernInputDecoration(
                                        hintText:
                                            S.of(context).confirmPasswordA,
                                        icon: Icons.lock_outline,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isHidden1 = !_isHidden1;
                                            });
                                          },
                                          child: Icon(
                                            _isHidden1
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: _softText,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      obscureText: _isHidden1,
                                    ),

                                    SizedBox(height: 22.h),
                                    if (_showUnavailableInvitationInfo) ...[
                                      _unavailableInvitationInfo(),
                                      SizedBox(height: 12.h),
                                    ],
                                    if (!_hasRecognizedDiscoveryInvitation) ...[
                                      _promoCodeSection(),
                                      const SizedBox(height: 15),
                                    ],

                                    if (_currentRegistrationCode != null &&
                                        !_registrationCodeValidationFailed)
                                      _appliedAttributionLabel(
                                        _currentRegistrationCodeResolution
                                                    ?.displayName !=
                                                null
                                            ? 'Invitation detected: ${_currentRegistrationCodeResolution!.displayName}'
                                            : 'Your Discovery invitation has been recognised',
                                      ),

                                    // Select Charity

                                    // FutureBuilder<NearByCharityListResModel?>(
                                    //     future: nearByCharityForReg,
                                    //     builder: (context, snapshot) {
                                    //       if (!snapshot.hasData) {
                                    //         return Container(
                                    //           padding: const EdgeInsets.only(
                                    //               left: 25, right: 25, top: 15),
                                    //           height: 50.h,
                                    //           width: double.infinity,
                                    //           decoration: BoxDecoration(
                                    //             color: GlobalColors.paleGray,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5.0),
                                    //           ),
                                    //           child: InkWell(
                                    //             onTap: () {
                                    //               if (selectedCountryID == null) {
                                    //                 GlobalSnackBar.valid(
                                    //                     context,
                                    //                     S
                                    //                         .of(context)
                                    //                         .pleaseSelectCountryFirstToSelectCharity);
                                    //               } else if (AppVariables
                                    //                       .locationEnabledStatus
                                    //                       .value <
                                    //                   2) {
                                    //                 LocationService()
                                    //                     .enableLocationAndFetchCountry()
                                    //                     .then((value) {
                                    //                   if (value == true) {
                                    //                     setState(() {
                                    //                       nearByCharityForReg =
                                    //                           getNearByCharityForReg(
                                    //                               selectedCountryID!);
                                    //                     });
                                    //                   }
                                    //                 });
                                    //               }
                                    //             },
                                    //             child: AutoSizeText(
                                    //               S.of(context).selectCharity,
                                    //               // 'Select Charity',
                                    //               style: TextStyle(
                                    //                   color: GlobalColors.gray
                                    //                       .withValues(alpha: 0.8),
                                    //                   fontSize: 15.sp,
                                    //                   fontWeight: FontWeight.w500),
                                    //             ),
                                    //           ),
                                    //         );
                                    //       } else {
                                    //         return Container(
                                    //           height: 50.h,
                                    //           width: double.infinity,
                                    //           decoration: BoxDecoration(
                                    //             color: GlobalColors.paleGray,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5.0),
                                    //           ),
                                    //           child: snapshot.data!.data!.isEmpty
                                    //               ? Padding(
                                    //                   padding: const EdgeInsets.only(
                                    //                       top: 15.0,
                                    //                       left: 25.0,
                                    //                       right: 25.0),
                                    //                   child: AutoSizeText(
                                    //                     S
                                    //                         .of(context)
                                    //                         .noCharityAvailable,
                                    //                     style: locationStyle.copyWith(
                                    //                         fontWeight:
                                    //                             FontWeight.w500),
                                    //                   ),
                                    //                 )
                                    //               : iscountryChanged == true
                                    //                   ? Padding(
                                    //                       padding:
                                    //                           const EdgeInsets.only(
                                    //                               top: 15,
                                    //                               left: 25,
                                    //                               right: 25),
                                    //                       child: AutoSizeText(
                                    //                         S.of(context).pleaseWait,
                                    //                         style: locationStyle
                                    //                             .copyWith(
                                    //                                 fontWeight:
                                    //                                     FontWeight
                                    //                                         .w500),
                                    //                       ),
                                    //                     )
                                    //                   : DropdownButtonWidget(
                                    //                       label: S
                                    //                           .of(context)
                                    //                           .selectCharity,
                                    //                       searchController:
                                    //                           stateSearchController,
                                    //                       isExpanded: true,
                                    //                       bWidth: double.infinity,
                                    //                       iHeight: 35,
                                    //                       dropHeight: 175,
                                    //                       searchHeight: 40,
                                    //                       items: snapshot.data!.data!
                                    //                           .map((e) {
                                    //                         return DropdownMenuItem(
                                    //                           value: e.charityName,
                                    //                           child: Padding(
                                    //                             padding:
                                    //                                 const EdgeInsets
                                    //                                     .only(
                                    //                               left: 25,
                                    //                               top: 0,
                                    //                               bottom: 0,
                                    //                             ),
                                    //                             child: AutoSizeText(
                                    //                               e.charityName!,
                                    //                               style:
                                    //                                   dopdownTextStyle,
                                    //                             ),
                                    //                           ),
                                    //                         );
                                    //                       }).toList(),
                                    //                       onChanged: (newVal) async {
                                    //                         setState(() {
                                    //                           selectedCharity =
                                    //                               newVal as String;
                                    //                         });
                                    //                         final charityIDD = snapshot
                                    //                             .data!.data!
                                    //                             .firstWhere((element) =>
                                    //                                 element
                                    //                                     .charityName ==
                                    //                                 selectedCharity);
                                    //                         selectedCharityID =
                                    //                             charityIDD.id;
                                    //                       },
                                    //                       value: selectedCharity,
                                    //                     ),
                                    //         );
                                    //       }
                                    //     }),

                                    const SizedBox(height: 15),
                                    // I agree with the Term and Condition
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: _primaryBlue,
                                            side: const BorderSide(
                                                width: 2, color: _primaryBlue),
                                            // fillColor: WidgetStateProperty.all(
                                            //     GlobalColors.appColor),
                                            value: isChecked,
                                            // shape: const CircleBorder(),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Expanded(
                                          flex: 9,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: S
                                                        .of(context)
                                                        .iAgreeWithTheTermsAndCondition
                                                        .replaceAll('&C', ''),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: S
                                                            .of(context)
                                                            .iAgreeWithTheTermsAndCondition
                                                            .replaceAll(
                                                                'I agree with the',
                                                                '')
                                                            .replaceAll(
                                                                '&C',
                                                                S
                                                                    .of(context)
                                                                    .termsAndConditions),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: _primaryBlue,
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                context.pushNamed(
                                                                    'terms-condition'); // Navigate to terms
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),

                                    _gradientContinueButton(),
                                    SizedBox(height: 14.h),
                                    Text(
                                      'Next step: verify your mobile',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            _softText.withValues(alpha: 0.85),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    // Error State
                    else if (locationState is LocationAllErrorState) {
                      return const Error1();
                    }
                    // if none the state is executable
                    else {
                      return const SizedBox();
                    }
                  },
                ), //Location
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  //Check Issuer/Provider
  checkProvider() async {
    //Checking whether the Issuer/Provider code is valid or not
    if (providerController.text.isNotEmpty) {
      var proRes = await DioRegister().checkIssuerCode(
          issuerCode: providerController.text.trim(),
          countryId: selectedCountryID.toString());
      if (!mounted) return;
      if (proRes is CheckIssuerCodeResModel) {
        checkPremium();
      } else {
        setState(() {
          isLoading = false;
        });
        invalidIssuer();
      }
    } else {
      checkPremium();
    }
  }

  //Invalid Issuer/Provider Code
  invalidIssuer() {
    return showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(
          alpha:
              0.5), //to change the background color once the container is opened
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width / 1.1,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 10),
                //Text
                AutoSizeText(S.of(context).issuerCodeIsNotValid,
                    // 'Issuer Code is not Valid!',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: 'Sans')),
                const SizedBox(height: 10),

                // Button
                CustomButton(
                  text: S.of(context).ok,
                  onPressed: () {
                    context.pop();
                  },
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  // Missing Issuer Code Confirmation Dialog
  missingIssuerConfirmationDialog() {
    return showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // 1. REMOVED fixed height here
            width: MediaQuery.of(context).size.width / 1.1,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            padding: const EdgeInsets.all(
                20.0), // Increased padding slightly for breathing room
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                // 2. ADDED MainAxisSize.min so it only takes exactly as much height as needed
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text
                  AutoSizeText(
                    infoMessage ?? '__',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontFamily: 'Sans',
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Spacing between text and buttons

                  // Buttons (Cancel & Continue)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).cancel,
                          onPressed: () {
                            context.pop(); // Dismiss dialog
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: S.of(context).continueL,
                          onPressed: () async {
                            context.pop(); // Dismiss dialog
                            setState(() {
                              isLoading = true;
                            });

                            // 1. Check if email/phone already exists
                            bool? validityResult = await checkEmailAndPhoneNo();

                            if (validityResult == false) {
                              // 2. Validate the premium code (with an empty issuer code)
                              var preRes = await DioRegister().premiumVal(
                                premiumValidityReqModel:
                                    PremiumValidityReqModel(
                                  memberPremiumCode: premiumController.text
                                      .trim()
                                      .toUpperCase(),
                                  issuerCode:
                                      providerController.text.trim().isEmpty
                                          ? null
                                          : providerController.text.trim(),
                                  membershipCountryId: selectedCountryID,
                                ),
                              );

                              if (!mounted) return;

                              if (preRes is CommonResModel) {
                                if (preRes.status == 'success') {
                                  // 3. Everything is valid, send the OTP!
                                  sendPhoneOtp();
                                } else {
                                  _showPremiumCodeVerificationMessage();
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              } else {
                                // Invalid premium code format/error
                                setState(() {
                                  isLoading = false;
                                });
                                invalidPremium();
                              }
                            } else {
                              // Email or Phone already exists
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  // Check a pending canonical invitation, a manually entered registration
  // code, or an unchanged legacy Branch Premium code.
  checkPremium() async {
    final String manualCode = premiumController.text.trim().toUpperCase();
    final String? pendingDiscoveryCode = _currentRegistrationCode;
    final String? legacyBranchPremiumCode =
        _nonEmptyCode(widget.memberPremiumCode);

    if (manualCode.isNotEmpty &&
        legacyBranchPremiumCode != null &&
        manualCode == legacyBranchPremiumCode.toUpperCase() &&
        pendingDiscoveryCode == null) {
      await _validateLegacyPremiumCode(manualCode);
      return;
    }

    final String? codeToResolve =
        manualCode.isNotEmpty ? manualCode : pendingDiscoveryCode;
    if (codeToResolve == null) {
      sendPhoneOtp();
      return;
    }

    final resolution = await DioRegister().resolveRegistrationCode(
      code: codeToResolve,
      countryId: selectedCountryID!,
    );
    if (!mounted) return;
    if (!resolution.valid) {
      final manuallyEntered = manualCode.isNotEmpty;
      final shouldClearPending =
          shouldClearPendingInvitationAfterValidationFailure(
        resolution: resolution,
        manuallyEntered: manuallyEntered,
      );
      if (shouldClearPending) {
        await BranchReferralService.clearPendingDiscoveryReferral(
          code: pendingDiscoveryCode,
        );
        if (!mounted) return;
      }
      if (shouldClearPending) {
        _recoverFromUnavailableLinkedInvitation();
      } else {
        GlobalSnackBar.showError(
          context,
          registrationCodeValidationMessage(
            resolution,
            manuallyEntered: manuallyEntered,
          ),
        );
        setState(() {
          isLoading = false;
          _registrationCodeValidationFailed = true;
        });
      }
      return;
    }

    if (manualCode.isEmpty &&
        pendingDiscoveryCode != null &&
        !resolution.isDiscovery) {
      GlobalSnackBar.showError(
        context,
        'This link does not resolve to a Discovery invitation. The invitation has not been applied.',
      );
      setState(() {
        isLoading = false;
        _registrationCodeValidationFailed = true;
      });
      return;
    }

    final bool replacesPendingDiscovery = registrationCodeReplacementRequired(
          pendingDiscoveryCode: pendingDiscoveryCode,
          candidateCode: codeToResolve,
        ) ||
        (manualCode.isNotEmpty &&
            pendingDiscoveryCode != null &&
            !resolution.isDiscovery);
    if (replacesPendingDiscovery) {
      final confirmed = await _confirmRegistrationCodeReplacement(
        resolution,
      );
      if (!mounted) return;
      if (!confirmed) {
        setState(() => isLoading = false);
        return;
      }
      if (resolution.isDiscovery) {
        await BranchReferralService.replacePendingDiscoveryReferral(
          BranchRegistrationReferral(
            discoveryInvitationCode: codeToResolve,
            campaign: resolution.campaignName,
            invitationName: resolution.invitationName,
            type: BranchReferralType.discoveryInvitation,
          ),
        );
      } else {
        await BranchReferralService.clearPendingDiscoveryReferral(
          code: pendingDiscoveryCode,
        );
      }
    }
    if (!replacesPendingDiscovery &&
        manualCode.isNotEmpty &&
        resolution.isDiscovery &&
        pendingDiscoveryCode == null) {
      await BranchReferralService.replacePendingDiscoveryReferral(
        BranchRegistrationReferral(
          discoveryInvitationCode: codeToResolve,
          campaign: resolution.campaignName,
          invitationName: resolution.invitationName,
          type: BranchReferralType.discoveryInvitation,
        ),
      );
    }

    _currentRegistrationCode = codeToResolve;
    _currentRegistrationCodeResolution = resolution;
    _registrationCodeValidationFailed = false;
    _showUnavailableInvitationInfo = false;
    final application = RegistrationCodeApplication.fromResolution(
      code: codeToResolve,
      resolution: resolution,
    );
    premiumController.text = application.localPremiumCode ?? '';
    if (application.memberReferralCode != null) {
      referralCodeController.text = application.memberReferralCode!;
    }
    if (application.issuerCode != null) {
      providerController.text = application.issuerCode!;
    }

    final bool? validityResult = await checkEmailAndPhoneNo();
    if (!mounted) return;
    if (validityResult == false) {
      sendPhoneOtp();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _validateLegacyPremiumCode(String premiumCodeInput) async {
    if (premiumCodeInput.isNotEmpty) {
      bool? validityResult = await checkEmailAndPhoneNo();
      if (validityResult == false) {
        var preRes = await DioRegister().premiumVal(
          premiumValidityReqModel: PremiumValidityReqModel(
            memberPremiumCode: premiumCodeInput,
            issuerCode: providerController.text.trim().isEmpty
                ? null
                : providerController.text.trim(),
            membershipCountryId: selectedCountryID,
          ),
        );
        if (!mounted) return;
        if (preRes is CommonResModel) {
          if (preRes.status == 'success') {
            sendPhoneOtp();
          } else {
            _showPremiumCodeVerificationMessage();
            setState(() {
              isLoading = false;
            });
          }
        }
        // If invalid premium code is provided
        else {
          setState(() {
            isLoading = false;
          });
          invalidPremium();
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      sendPhoneOtp();
    }
  }

  Future<bool> _confirmRegistrationCodeReplacement(
    RegistrationCodeResolution replacement,
  ) async {
    final replacementType = replacement.isPremium
        ? 'Premium offer'
        : replacement.isDiscovery
            ? 'Discovery invitation'
            : 'registration attribution';
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Replace detected invitation?'),
            content: Text(
              'A Discovery invitation is already linked to this registration. '
              'Using this $replacementType will replace it. The two offers cannot be combined.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Keep invitation'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Replace'),
              ),
            ],
          ),
        ) ??
        false;
  }

  //Invalid Premium Code
  invalidPremium() {
    _showPremiumCodeVerificationMessage();
  }

  void _showPremiumCodeVerificationMessage() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFFFF7E6),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          content: Text(
            'This premium code could not be verified. Please check the code and try again.',
            style: TextStyle(
              color: const Color(0xFF5A4A12),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          action: SnackBarAction(
            label: S.of(context).ok,
            textColor: _primaryBlue,
            onPressed: () {},
          ),
        ),
      );
  }

  Future<bool?> checkEmailAndPhoneNo() async {
    var res = await DioRegister().checkEmailAndPhoneNo(
      emailmemberOtpReqModel: EmailMemberOtpReqModel(
        phoneNumberPrefix: selectedPhonePrefix!,
        phoneNumber: mobileNumberController.text.trim(),
        email: emailController.text.trim(),
        // countryId: selectedCountryID!,
        memberReferralCode: null,
      ),
    );
    if (!mounted) return false;
    if (res == true) {
      GlobalSnackBar.showError(
          context, S.of(context).emailOrPhoneNumberAlreadyExists);
      return true;
    } else {
      return res;
    }
  }

  //sending email otp
  sendPhoneOtp() async {
    var res = await DioRegister().createPhoneOtp(
      phoneOtpReq: PhoneOtpReq(
        phoneNumberPrefix: selectedPhonePrefix,
        phoneNumber: mobileNumberController.text.trim(),
        phoneVerifiedBy: 'sms',
        email: emailController.text.trim(),
        countryId: selectedCountryID!,
        appSign: getAsign,
        memberReferralCode: referralCodeController.text.trim(),
      ),
    );
    if (!mounted) return;
    if (res is CommonResModel) {
      if (res.status == 'Success') {
        context.pushNamed('number-reg-otp', extra: {
          'countryID': selectedCountryID,
          'membershipCountryId': selectedCountryID,
          'stateID': selectedStateID,
          'charityID': selectedCharityID ?? 0,
          'issuerCode': providerController.text.isEmpty
              ? 'null'
              : providerController.text.trim(),
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phonePrefix': selectedPhonePrefix,
          'phoneVerifiedBy': 'sms',
          'confirmPassword': confirmPassowrdController.text.trim(),
          'phNum': mobileNumberController.text.trim(),
          'residenceCountryReferenceId': selectedResidenceCountryID,
          'residentialPostalCode': selectedResidenceUsesPostalCode
              ? residentialPostalCodeController.text.trim()
              : null,
          'premium': premiumController.text.isEmpty
              ? 'null'
              : premiumController.text.trim().toUpperCase(),
          'discoveryInvitationCode': 'null',
          'registrationCode': _currentRegistrationCode ?? 'null',
          'referralCode': referralCodeController.text.isEmpty
              ? 'null'
              : referralCodeController.text.trim(),
        });
      }
    } else if (res == 409) {
      GlobalSnackBar.showError(
          context, S.of(context).emailOrPhoneNumberAlreadyExists);
    } else if (res.toString().contains('is not a valid phone number')) {
      // log(res.toString());
      GlobalSnackBar.showError(context, res.toString());
    } else {
      // log(res.toString());
      GlobalSnackBar.showError(context, res.toString());
    }
    setState(() {
      isLoading = false;
    });
  }
}
