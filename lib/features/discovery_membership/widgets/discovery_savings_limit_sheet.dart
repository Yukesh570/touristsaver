import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/common/widgets/custom_snackbar.dart';
import 'package:touristsaver/features/discovery_membership/services/discovery_premium_continuation_flow.dart';
import 'package:touristsaver/features/profile/services/dio_membership.dart';
import 'package:touristsaver/models/error_res.dart';

const String discoverySavingsCapErrorCode = 'DISCOVERY_SAVINGS_CAP_REACHED';

bool isDiscoverySavingsCapResponse(dynamic response) =>
    response is ErrorResModel && response.code == discoverySavingsCapErrorCode;

bool canPresentDiscoverySavingsLimit({
  required String? memberType,
  required DiscoveryMembershipContext? membership,
}) {
  final String normalizedMemberType = memberType?.trim().toLowerCase() ?? '';
  final continuation = membership?.continuation;
  return normalizedMemberType != 'premium' &&
      membership != null &&
      !membership.isActive &&
      membership.endReason == 'savings_cap_reached' &&
      membership.effectiveSavingsConsumedAmount != null &&
      continuation?.eligible == true &&
      (continuation!.complimentary || continuation.priceAmountMinor != null);
}

Future<bool> showDiscoverySavingsLimitSheetForResponse({
  required BuildContext context,
  required dynamic response,
}) async {
  if (!isDiscoverySavingsCapResponse(response)) return false;

  final profile = await DioMemberShip().getUserProfile();
  if (!context.mounted) return true;
  final String? memberType = profile?.data?.results?.memberType;
  final DiscoveryMembershipContext? membership =
      profile?.data?.discoveryMembership;

  // The backend code and the terminal Discovery entitlement must agree. This
  // prevents a stale Discovery record from affecting a genuine Premium member.
  if (!canPresentDiscoverySavingsLimit(
    memberType: memberType,
    membership: membership,
  )) {
    GlobalSnackBar.showError(
      context,
      'We could not load your Premium continuation details. Please try again.',
    );
    return true;
  }

  final DiscoveryMembershipContext presentableMembership = membership!;
  await const DiscoveryMembershipStore().save(presentableMembership);
  if (!context.mounted) return true;
  final bool activated = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            DiscoverySavingsLimitSheet(membership: presentableMembership),
      ) ??
      false;
  if (activated && context.mounted) {
    GlobalSnackBar.showSuccess(
      context,
      'Your Premium Membership is now active.',
    );
  }
  return true;
}

class DiscoverySavingsLimitSheet extends StatefulWidget {
  const DiscoverySavingsLimitSheet({
    super.key,
    required this.membership,
    this.continuationFlow = const DiscoveryPremiumContinuationFlow(),
  });

  final DiscoveryMembershipContext membership;
  final DiscoveryPremiumContinuationFlow continuationFlow;

  @override
  State<DiscoverySavingsLimitSheet> createState() =>
      _DiscoverySavingsLimitSheetState();
}

class _DiscoverySavingsLimitSheetState
    extends State<DiscoverySavingsLimitSheet> {
  static const Color _brandBlue = Color(0xFF0009FE);
  static const Color _ctaCyan = Color(0xFF18C6FF);
  static const Color _navy = Color(0xFF111C44);
  static const Color _muted = Color(0xFF63708A);

  bool _loading = false;
  String? _statusMessage;

  Future<void> _continueWithPremium() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _statusMessage = null;
    });
    final result =
        await widget.continuationFlow.continueWith(widget.membership);
    if (!mounted) return;
    if (result.status == DiscoveryContinuationStatus.activated) {
      await const DiscoveryMembershipStore().save(
        widget.membership.withAcceptedPremiumContinuation(),
      );
      if (mounted) Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _loading = false;
      _statusMessage = result.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final continuation = widget.membership.continuation!;
    final double saved = widget.membership.effectiveSavingsConsumedAmount ?? 0;
    final String savedAmount =
        '${widget.membership.displayCurrency}${NumberFormat('#,##0.00').format(saved)}';
    final String ctaLabel = continuation.complimentary
        ? 'Activate Complimentary Premium'
        : 'Continue with Premium for ${continuation.displayPrice}';

    return SafeArea(
      top: false,
      child: Container(
        key: const Key('discovery-savings-limit-sheet'),
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7DDEC),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              SizedBox(height: 22.h),
              Container(
                width: 66.r,
                height: 66.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_brandBlue, _ctaCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.celebration_rounded,
                    color: Colors.white, size: 34.r),
              ),
              SizedBox(height: 18.h),
              Text(
                'You’ve reached your Discovery savings limit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _navy,
                  fontSize: 22.sp,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Sans',
                ),
              ),
              SizedBox(height: 14.h),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: _muted,
                    fontSize: 15.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Sans',
                  ),
                  children: [
                    const TextSpan(text: 'Great news, you’ve already saved '),
                    TextSpan(
                      text: savedAmount,
                      style: const TextStyle(
                        color: _brandBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text: ' with your TouristSaver Discovery Membership.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Continue with Premium to keep enjoying member savings at participating TouristSaver merchants.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted,
                  fontSize: 15.sp,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Sans',
                ),
              ),
              if (_statusMessage != null) ...[
                SizedBox(height: 12.h),
                Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: 22.h),
              Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: const LinearGradient(
                    colors: [_brandBlue, _ctaCyan],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('continue-discovery-premium-from-limit'),
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: _loading ? null : _continueWithPremium,
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              ctaLabel,
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
              SizedBox(height: 8.h),
              TextButton(
                key: const Key('dismiss-discovery-savings-limit'),
                onPressed:
                    _loading ? null : () => Navigator.of(context).pop(false),
                child: Text(
                  'Not now',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
