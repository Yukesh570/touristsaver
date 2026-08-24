// import 'dart:developer';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/common/widgets/custom_app_bar.dart';
import 'package:touristsaver/common/widgets/error.dart';
import 'package:touristsaver/common/widgets/touristsaver_loading_view.dart';
import 'package:touristsaver/constants/style.dart';
import 'package:touristsaver/features/connectivity/cubit/internet_cubit.dart';
import 'package:touristsaver/features/details/services/dio_detail.dart';
import 'package:touristsaver/features/discovery_membership/services/discovery_premium_continuation_flow.dart';
import 'package:touristsaver/features/profile/services/dio_membership.dart';
import 'package:touristsaver/features/transaction/services/dio_transaction.dart';
import 'package:touristsaver/features/wallet/services/dio_wallet.dart';
import 'package:touristsaver/models/response/detail_res.dart' as detail;
import 'package:touristsaver/models/response/transaction_res.dart'
    as transaction;
import 'package:touristsaver/models/response/universal_get_my_wallet.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../constants/pref.dart';
import '../../../constants/pref_key.dart';
import '../../../models/request/rate_merchant_req.dart';
import '../../../models/response/get_free_piiinks_res_model.dart';
import '../../../models/response/is_pay_enable_res.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../merchant/services/dio_reviews.dart';
import '../../payment/services/dio_payment.dart';
import 'package:touristsaver/generated/l10n.dart';

String savingsHeadline({required bool usesDiscoveryWording}) =>
    usesDiscoveryWording ? 'Discovery Savings' : 'TouristSaver Savings';

String savingsProgressDescription({required bool usesDiscoveryWording}) =>
    usesDiscoveryWording
        ? 'Your TouristSaver Discovery Membership savings achieved so far.'
        : 'Your TouristSaver Membership savings achieved so far.';

class LogWalletScreen extends StatefulWidget {
  static const String routeName = '/wallet-screen';
  const LogWalletScreen({super.key});

  @override
  State<LogWalletScreen> createState() => _LogWalletScreenState();
}

class _LogWalletScreenState extends State<LogWalletScreen> {
  static const Color _primaryBlue = Color(0xFF0009FE);
  static const Color _screenBackground = Color(0xFFF8FAFE);
  static const Color _headingColor = Color(0xFF111C44);
  static const Color _bodyColor = Color(0xFF61708A);
  static const Color _borderColor = Color(0xFFE2E8F3);
  static const Color _chipBackground = Color(0xFFF5F8FF);
  static const Color _selectedChipBackground = Color(0xFFEAF7FF);
  static const List<String> _feedbackOptions = [
    'Great Value',
    'Friendly Staff',
    'Excellent Service',
    'Quality Products',
    'Clean Venue',
    'Would Visit Again',
  ];
  bool? isTopUpEnabled;
  bool? canClaimFreePiiinks;
  bool? isFreePiiinksProvided;
  bool? isTopUpOnRegister;
  double? universalFreePiiinks;
  //For Sending the universal piiink as an argument
  double? sendUniPiiink;
  bool isLoading = false;
  DiscoveryMembershipContext? _discoveryMembership;
  DateTime? _premiumExpiryDate;
  bool _continuationLoading = false;

  bool get _showDiscoverySavingsWording => usesDiscoverySavingsWording(
        discoveryMembership: _discoveryMembership,
        premiumExpiryDate: _premiumExpiryDate,
      );

  Future<void> _loadDiscoveryMembership() async {
    final storedMembership = await const DiscoveryMembershipStore().read();
    final profile = await DioMemberShip().getUserProfile();
    final DiscoveryMembershipContext? membership =
        profile?.data?.discoveryMembership ?? storedMembership;
    if (profile?.data?.discoveryMembership != null) {
      await const DiscoveryMembershipStore().save(membership!);
    }
    if (!mounted) return;
    setState(() => _discoveryMembership = membership);
  }

  Future<void> _continueDiscoveryWithPremium() async {
    final membership = _discoveryMembership;
    if (membership == null || _continuationLoading) return;
    setState(() => _continuationLoading = true);
    final result =
        await const DiscoveryPremiumContinuationFlow().continueWith(membership);
    if (!mounted) return;
    if (result.status == DiscoveryContinuationStatus.activated) {
      final activated = membership.withAcceptedPremiumContinuation();
      await const DiscoveryMembershipStore().save(activated);
      if (!mounted) return;
      setState(() => _discoveryMembership = activated);
      GlobalSnackBar.showSuccess(
        context,
        'Your Premium Membership is now active.',
      );
    } else if (result.status == DiscoveryContinuationStatus.cancelled) {
      GlobalSnackBar.valid(
        context,
        result.message ?? 'Payment cancelled. No charge was made.',
      );
    } else {
      GlobalSnackBar.showError(
        context,
        result.message ?? 'Payment could not be completed. Please try again.',
      );
    }
    if (mounted) setState(() => _continuationLoading = false);
  }

  Future<void> getFreePiiinksInfo() async {
    GetFreePiinksResModel? getFreePiinksResModel = await DioWallet().getFree();
    universalFreePiiinks =
        getFreePiinksResModel?.data?.universalPiiinks!.toDouble();
    // log({getFreePiinksResModel?.data?.universalPiiinks}.toString());
  }

  Future<void> getPaymentInfo() async {
    IsPayEnableResModel? isPayEnabledResModel = await DioPay().payEnabled();
    if (!mounted) return;
    setState(() {
      isTopUpEnabled = isPayEnabledResModel?.data?.transactionIsEnabled;
    });
  }

  // Calling the user wallet
  Future<UniversalGetMyWallet?>? walletLoad;
  Future<transaction.TransactionResModel?>? recentSavingsLoad;
  Future<UniversalGetMyWallet?> loadWallet() async {
    setState(() {
      isLoading = false;
    });
    UniversalGetMyWallet? getWallet = await DioWallet().getUniverslUserWallet();
    setState(() {
      isTopUpOnRegister = getWallet!.data!.isTopUpOnRegister;
      canClaimFreePiiinks = getWallet.data!.canClaimFreePiiinks;
      isFreePiiinksProvided = getWallet.data!.isFreePiiinksProvided;
      _premiumExpiryDate = getWallet.data!.premiumExpiryDate;
      isLoading = true;
    });
    return getWallet;
  }

  Future<transaction.TransactionResModel?> loadRecentSavings() async {
    final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
    final DateTime now = DateTime.now();
    final String latestDate = apiDateFormat.format(now);
    const String previousDate = '2000-01-01';

    return DioTransaction().transac(previousDate, latestDate);
  }

  int? merchantId;
  bool showReviewPopUp = false;

  late double _rating;
  final int _ratingBarMode = 0;
  final double _initialRating = 0;
  IconData? _selectedIcon;
  var _defaultChoiceIndex;
  String? selectedString;
  bool reviewLoading = false;
  bool reviewSubmitted = false;
  bool isSelected = false;
  final Map<int, Future<String?>> _merchantImageLoads = {};

  void _finishReviewSequenceToHome() {
    AppVariables.payAmountResetSignal.value++;
    context.goNamed(
      'bottom-bar',
      pathParameters: {'page': '0'},
    );
  }

  @override
  void initState() {
    _loadDiscoveryMembership();
    getPaymentInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showReviewPopUp = await Pref().readBool(key: showReview) ?? false;
      merchantId = await Pref().readInt(key: addReviewMerchantID);
      _rating = _initialRating;
      if (showReviewPopUp == true) {
        _showAddReviewDialog();
      }
    });

    getFreePiiinksInfo();
    walletLoad = loadWallet();
    recentSavingsLoad = loadRecentSavings();
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityCubit().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(text: 'My Savings'),
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      40.h,
                ),
                child: state == ConnectivityState.loading
                    ? const NoInternetLoader()
                    : state == ConnectivityState.disconnected
                        ? const NoInternetWidget()
                        : _connectedSavingsDashboard(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _connectedSavingsDashboard() {
    return FutureBuilder<UniversalGetMyWallet?>(
      future: walletLoad,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ProfileError();
        } else if (!snapshot.hasData || isLoading == false) {
          return const TouristSaverLoadingView();
        }

        final UniversalGetMyWallet wallet = snapshot.data!;
        sendUniPiiink = wallet.data?.balance ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _premiumSavingsHeroCard(),
            if (_discoveryMembership?.isActive == false &&
                _discoveryMembership?.continuation?.accepted != true) ...[
              SizedBox(height: 16.h),
              DiscoveryMembershipCompletionCard(
                membership: _discoveryMembership!,
                loading: _continuationLoading,
                onContinue: _discoveryMembership!.continuation?.eligible == true
                    ? _continueDiscoveryWithPremium
                    : null,
              ),
            ],
            SizedBox(height: 16.h),
            _recentSavingsSection(),
            SizedBox(height: 16.h),
            _premiumMembershipValueCard(),
            SizedBox(height: 16.h),
            _merchantSavingsSection(),
            SizedBox(height: 16.h),
            _moreOptionsSection(),
          ],
        );
      },
    );
  }

  Widget _premiumSavingsHeroCard() {
    return FutureBuilder<transaction.TransactionResModel?>(
      future: recentSavingsLoad,
      builder: (context, snapshot) {
        final double? totalSavings = snapshot.hasData
            ? _totalMemberSavings(_latestSavings(snapshot.data!))
            : null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFEFF7FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: _borderColor),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A236B).withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F3FF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.savings_outlined,
                    color: _primaryBlue,
                    size: 25.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                savingsHeadline(
                  usesDiscoveryWording: _showDiscoverySavingsWording,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _headingColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Sans',
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                totalSavings == null
                    ? 'Loading...'
                    : _formatCurrency(totalSavings),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryBlue,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                  fontFamily: 'Sans',
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                savingsProgressDescription(
                  usesDiscoveryWording: _showDiscoverySavingsWording,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _bodyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  fontFamily: 'Sans',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _premiumMembershipValueCard() {
    return _SavingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.info_outline,
            title: 'How Your Savings Work',
          ),
          SizedBox(height: 12.h),
          Text(
            'TouristSaver Savings are the value you receive when participating merchants apply your member discount.',
            style: _bodyTextStyle(),
          ),
          SizedBox(height: 14.h),
          Divider(color: _borderColor, height: 1),
          SizedBox(height: 14.h),
          _exampleRow('Bill total', '\$100'),
          _exampleRow('Member discount', '10%'),
          _exampleRow('You pay merchant', '\$90'),
          _exampleRow('You saved', '\$10.00'),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _showPremiumSavingsExplainer,
              style: TextButton.styleFrom(
                foregroundColor: _primaryBlue,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Learn more',
                style: TextStyle(
                  color: _primaryBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentSavingsSection() {
    return _SavingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<transaction.TransactionResModel?>(
            future: recentSavingsLoad,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  children: [
                    _recentSavingsHeader(),
                    SizedBox(height: 10.h),
                    TouristSaverLoadingView(
                      height: 80.h,
                      spinnerSize: 24,
                      strokeWidth: 2,
                    ),
                  ],
                );
              }

              final List<transaction.Datum> allSavings =
                  _latestSavings(snapshot.data!);
              final List<transaction.Datum> transactions = allSavings;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _recentSavingsHeader(transactionCount: transactions.length),
                  SizedBox(height: 10.h),
                  if (transactions.isEmpty)
                    Text(
                      'Your recent savings will appear here after you use TouristSaver with participating merchants.',
                      style: _bodyTextStyle(),
                    )
                  else
                    SizedBox(
                      height: _recentSavingsListHeight(transactions.length),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 6.h),
                        itemBuilder: (context, index) {
                          return _recentSavingTile(transactions[index]);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _recentSavingsHeader({int? transactionCount}) {
    final String? countLabel = transactionCount == null
        ? null
        : '$transactionCount ${transactionCount == 1 ? 'transaction' : 'transactions'}';

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.history_outlined, color: _primaryBlue, size: 22.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6.w,
                  runSpacing: 2.h,
                  children: [
                    Text(
                      'Recent savings',
                      style: TextStyle(
                        color: _headingColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Sans',
                      ),
                    ),
                    if (countLabel != null)
                      Text(
                        '· $countLabel',
                        style: TextStyle(
                          color: _bodyColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Sans',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _openTransactionHistory,
          style: TextButton.styleFrom(
            foregroundColor: _primaryBlue,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
          ),
          child: Text(
            'Transaction History',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentSavingTile(transaction.Datum transaction) {
    final String merchantName =
        transaction.merchant?.merchantName ?? 'Participating merchant';
    final String date = transaction.transactionDate == null
        ? ''
        : DateFormat('d MMM yyyy')
            .format(transaction.transactionDate!.toLocal());
    final String discount = _formatCurrency(transaction.discountAmount ?? 0);
    final String? merchantImageUrl = _merchantImageUrl(transaction);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _recentSavingMerchantImage(
            merchantImageUrl,
            merchantId: transaction.merchantId,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchantName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _headingColor,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Sans',
                  ),
                ),
                if (date.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _captionTextStyle(),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 7.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 94.w),
            child: Text(
              'Saved $discount',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 12.25.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _recentSavingsListHeight(int itemCount) {
    final int visibleItems = itemCount < 6 ? itemCount : 6;
    final double rowHeight = 62.h;
    final double separatorHeight = 6.h;
    return (visibleItems * rowHeight) +
        ((visibleItems - 1).clamp(0, 5) * separatorHeight);
  }

  Widget _recentSavingMerchantImage(String? imageUrl, {int? merchantId}) {
    final String? url =
        imageUrl == null || imageUrl.trim().isEmpty ? null : imageUrl.trim();
    if (url == null && merchantId != null) {
      return FutureBuilder<String?>(
        future: _merchantImageFuture(merchantId),
        builder: (context, snapshot) {
          return _recentSavingMerchantImageFrame(
            snapshot.data,
            isLoading: snapshot.connectionState != ConnectionState.done,
          );
        },
      );
    }

    return _recentSavingMerchantImageFrame(url);
  }

  Widget _recentSavingMerchantImageFrame(
    String? imageUrl, {
    bool isLoading = false,
  }) {
    final String? url =
        imageUrl == null || imageUrl.trim().isEmpty ? null : imageUrl.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 50.w,
        height: 50.w,
        color: const Color(0xFFF2F6FC),
        child: isLoading
            ? _recentSavingImageLoader()
            : url == null
                ? _recentSavingFallbackImage()
                : CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _recentSavingImageLoader(),
                    errorWidget: (context, url, error) =>
                        _recentSavingFallbackImage(),
                  ),
      ),
    );
  }

  Widget _recentSavingImageLoader() {
    return Center(
      child: SizedBox(
        width: 18.w,
        height: 18.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: _primaryBlue,
        ),
      ),
    );
  }

  Future<String?> _merchantImageFuture(int merchantId) {
    return _merchantImageLoads.putIfAbsent(
      merchantId,
      () => _loadMerchantImage(merchantId),
    );
  }

  Future<String?> _loadMerchantImage(int merchantId) async {
    final DateTime now = DateTime.now();
    final detail.MerchantDetailResModel? merchantDetail =
        await DioDetail().getMerchantDetail(
      id: merchantId,
      day: DateFormat('EEEE').format(now),
      hour: now.hour,
    );
    final detail.MerchantImageInfo? imageInfo =
        merchantDetail?.data?.merchantImageInfo;
    return _firstNotEmpty([
      imageInfo?.logoUrl,
      imageInfo?.slider1,
      imageInfo?.slider2,
      imageInfo?.slider3,
      imageInfo?.slider4,
      imageInfo?.slider5,
      imageInfo?.slider6,
    ]);
  }

  Widget _recentSavingFallbackImage() {
    return Image.asset('assets/images/no_image.jpg', fit: BoxFit.cover);
  }

  String? _merchantImageUrl(transaction.Datum transactionData) {
    final transaction.Merchant? merchant = transactionData.merchant;
    return _firstNotEmpty([
      transactionData.merchantImageInfo?.logoUrl,
      merchant?.merchantImageInfo?.logoUrl,
      merchant?.logoUrl,
      transactionData.merchantImageInfo?.slider1,
      merchant?.merchantImageInfo?.slider1,
      transactionData.merchantImageInfo?.slider2,
      merchant?.merchantImageInfo?.slider2,
      transactionData.merchantImageInfo?.slider3,
      merchant?.merchantImageInfo?.slider3,
      transactionData.merchantImageInfo?.slider4,
      merchant?.merchantImageInfo?.slider4,
      transactionData.merchantImageInfo?.slider5,
      merchant?.merchantImageInfo?.slider5,
    ]);
  }

  String? _firstNotEmpty(List<String?> values) {
    for (final String? value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  Widget _merchantSavingsSection() {
    return _SavingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.storefront_outlined,
            title: 'View Merchant Savings',
          ),
          SizedBox(height: 10.h),
          Text(
            'See the total savings made from your membership.',
            style: _bodyTextStyle(),
          ),
          SizedBox(height: 14.h),
          _outlineLinkButton(
            label: 'View merchant savings',
            icon: Icons.arrow_forward_rounded,
            onTap: () => context.pushNamed('merchant-wallet'),
          ),
        ],
      ),
    );
  }

  Widget _moreOptionsSection() {
    return _SavingsCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 2.h),
          childrenPadding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 16.h),
          iconColor: _primaryBlue,
          collapsedIconColor: _primaryBlue,
          title: Text(
            'More options',
            style: TextStyle(
              color: _headingColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Sans',
            ),
          ),
          children: [
            _moreOptionTile(
              icon: Icons.public_outlined,
              label: 'Change Country',
              onTap: () {
                context.pushNamed('change-country').then((value) {
                  _refreshSavings();
                });
              },
            ),
            _moreOptionTile(
              icon: Icons.savings_outlined,
              label: 'Savings activity',
              onTap: () => context.pushNamed('top_up_history'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moreOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      enabled: onTap != null,
      leading: Icon(
        icon,
        color:
            onTap == null ? _bodyColor.withValues(alpha: 0.45) : _primaryBlue,
        size: 22.sp,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: onTap == null
              ? _bodyColor.withValues(alpha: 0.55)
              : _headingColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Sans',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: _bodyColor,
        size: 16.sp,
      ),
      onTap: onTap,
    );
  }

  Widget _outlineLinkButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _primaryBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Sans',
                ),
              ),
              SizedBox(width: 8.w),
              Icon(icon, color: _primaryBlue, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: _primaryBlue, size: 22.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: _headingColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Sans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _exampleRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: _bodyTextStyle()),
          ),
          Text(
            value,
            style: TextStyle(
              color: _headingColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Sans',
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _bodyTextStyle() {
    return TextStyle(
      color: _bodyColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      height: 1.42,
      fontFamily: 'Sans',
    );
  }

  TextStyle _captionTextStyle() {
    return TextStyle(
      color: _bodyColor,
      fontSize: 12.5.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Sans',
    );
  }

  List<transaction.Datum> _latestSavings(
      transaction.TransactionResModel model) {
    final List<transaction.Datum> transactions = model.data?.values
            .expand(
                (List<transaction.Datum> dayTransactions) => dayTransactions)
            .where((transaction.Datum item) => (item.discountAmount ?? 0) > 0)
            .toList() ??
        [];

    transactions.sort((transaction.Datum a, transaction.Datum b) {
      final DateTime aDate =
          a.transactionDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime bDate =
          b.transactionDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return transactions;
  }

  double _totalMemberSavings(List<transaction.Datum> transactions) {
    return transactions.fold<double>(
      0,
      (double total, transaction.Datum item) =>
          total + (item.discountAmount ?? 0),
    );
  }

  String _formatCurrency(num value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
  }

  Future<void> _refreshSavings() async {
    final Future<UniversalGetMyWallet?> newWalletLoad = loadWallet();
    final Future<transaction.TransactionResModel?> newRecentSavingsLoad =
        loadRecentSavings();

    setState(() {
      walletLoad = newWalletLoad;
      recentSavingsLoad = newRecentSavingsLoad;
    });

    await Future.wait([
      newWalletLoad,
      newRecentSavingsLoad,
    ]);
  }

  void _openTransactionHistory() {
    context.pushNamed('statement', pathParameters: {
      'uniBalance':
          sendUniPiiink.toString() != 'null' ? sendUniPiiink.toString() : '0',
    });
  }

  void _showPremiumSavingsExplainer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.all(16.r),
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(
                  icon: Icons.info_outline,
                  title: 'How Your Savings Work',
                ),
                SizedBox(height: 14.h),
                Text(
                  'TouristSaver Savings show the total value you have saved with participating merchants.',
                  style: _bodyTextStyle(),
                ),
                SizedBox(height: 12.h),
                Text(
                  'When a discount is redeemed, the saved amount contributes to your total TouristSaver Savings.',
                  style: _bodyTextStyle(),
                ),
                SizedBox(height: 12.h),
                Text(
                  'This is a membership success metric, not cash and not a withdrawable balance.',
                  style: _bodyTextStyle(),
                ),
                SizedBox(height: 18.h),
                _outlineLinkButton(
                  label: 'Got it',
                  icon: Icons.check_rounded,
                  onTap: () => context.pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddReviewDialog() {
    Pref().setBool(key: showReview, value: false);
    reviewSubmitted = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, stateMode) {
            return AlertDialog(
              title: Text(reviewSubmitted
                  ? 'Thank you for your review'
                  : S.of(context).addReview),
              content: SingleChildScrollView(
                child: SizedBox(
                  height: reviewSubmitted ? 170 : 320,
                  child: reviewSubmitted
                      ? _reviewSubmittedContent()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).rateThisMerchant,
                              style: topicStyle.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 15),
                            Center(child: _ratingBar(_ratingBarMode)),
                            const SizedBox(height: 15),
                            const Divider(
                              thickness: 2,
                            ),
                            const SizedBox(height: 15),
                            Text(S.of(context).yourFeedback,
                                style: topicStyle.copyWith(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            choiceChips(stateMode),
                          ],
                        ),
                ),
              ),
              actions: [
                if (reviewSubmitted)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 7.0),
                    child: CustomButton(
                      onPressed: () {
                        _finishReviewSequenceToHome();
                      },
                      text: 'Done',
                    ),
                  )
                else if (reviewLoading == true)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 7.0),
                    child: const CustomButtonWithCircular(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 7.0),
                    child: CustomButton(
                        onPressed: () {
                          onSendReview(onSuccess: () {
                            stateMode(() {
                              reviewSubmitted = true;
                            });
                          });
                        },
                        text: S.of(context).sendReview),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _reviewSubmittedContent() {
    return Center(
      child: Text(
        'Your feedback helps other TouristSaver members discover great merchants.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _bodyColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          height: 1.4,
          fontFamily: 'Sans',
        ),
      ),
    );
  }

  Widget choiceChips(stateMode) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _feedbackOptions.map((item) {
        final int index = _feedbackOptions.indexOf(item);
        final bool selected = _defaultChoiceIndex == index && isSelected;
        return ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          selectedColor: _selectedChipBackground,
          showCheckmark: selected,
          checkmarkColor: _primaryBlue,
          label: Text(
            item,
            overflow: TextOverflow.ellipsis,
          ),
          selected: selected,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selected ? _primaryBlue : _borderColor,
              width: selected ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: _chipBackground,
          labelStyle: TextStyle(
            color: selected ? _primaryBlue : _headingColor,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
          ),
          onSelected: (bool isChipSelected) {
            stateMode(() {
              _defaultChoiceIndex = isChipSelected ? index : null;
              isSelected = isChipSelected;
              selectedString = isChipSelected ? item : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.orange.withAlpha(50),
      itemCount: 5,
      itemSize: 30.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.orange,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  onSendReview({VoidCallback? onSuccess}) async {
    setState(() {
      reviewLoading = true;
    });

    if (_rating == 0.0 && selectedString == null) {
      GlobalSnackBar.valid(
          context, S.of(context).pleaseRateThisMerchantOrProvideFeedback);
      setState(() {
        reviewLoading = false;
      });
    } else {
      var rez = await DioReviews().createMerchantReviews(
          rateMerchantReqModel: RateMerchantReqModel(
              rating: _rating, merchantId: merchantId, review: selectedString));
      rez?.fold((l) {
        GlobalSnackBar.showError(context, l.message!);
        setState(() {
          reviewLoading = false;
        });
        return;
      }, (r) {
        if (r.status == 'Success') {
          setState(() {
            reviewLoading = false;
            reviewSubmitted = true;
          });
          onSuccess?.call();
        }
      });
    }
  }
}

class DiscoveryMembershipCompletionCard extends StatelessWidget {
  const DiscoveryMembershipCompletionCard({
    super.key,
    required this.membership,
    required this.loading,
    this.onContinue,
  });

  final DiscoveryMembershipContext membership;
  final bool loading;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final double? saved = membership.effectiveSavingsConsumedAmount;
    final continuation = membership.continuation;
    final String? continuationLabel = continuation?.eligible == true
        ? continuation!.complimentary
            ? 'Activate Complimentary Premium'
            : 'Continue with Premium for ${continuation.displayPrice}'
        : null;

    return Container(
      key: const Key('discovery-membership-completion-card'),
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFCAE0FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0009FE).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  color: const Color(0xFF0009FE),
                  size: 25.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'You’ve completed your Discovery Membership',
                  style: TextStyle(
                    color: const Color(0xFF111C44),
                    fontSize: 18.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Sans',
                  ),
                ),
              ),
            ],
          ),
          if (saved != null) ...[
            SizedBox(height: 14.h),
            Text(
              'You’ve enjoyed ${membership.displayCurrency}${NumberFormat('#,##0.00').format(saved)} in TouristSaver savings.',
              style: TextStyle(
                color: const Color(0xFF111C44),
                fontSize: 15.sp,
                height: 1.4,
                fontWeight: FontWeight.w800,
                fontFamily: 'Sans',
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            continuationLabel != null
                ? 'Keep saving with a full Premium Membership.'
                : 'Your Discovery Membership is complete. Your TouristSaver account remains active.',
            style: TextStyle(
              color: const Color(0xFF61708A),
              fontSize: 14.sp,
              height: 1.4,
              fontWeight: FontWeight.w600,
              fontFamily: 'Sans',
            ),
          ),
          if (continuationLabel != null && onContinue != null) ...[
            SizedBox(height: 18.h),
            Container(
              height: 52.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0009FE), Color(0xFF18C6FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('continue-premium-from-savings'),
                  onTap: loading ? null : onContinue,
                  borderRadius: BorderRadius.circular(17.r),
                  child: Center(
                    child: loading
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            continuationLabel,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  const _SavingsCard({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: _LogWalletScreenState._borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A236B).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
