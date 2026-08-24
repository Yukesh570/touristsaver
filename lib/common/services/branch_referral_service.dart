import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:touristsaver/constants/pref.dart';
import 'package:touristsaver/constants/pref_key.dart';

enum BranchReferralType {
  directIssuer,
  discoveryInvitation,
  memberInvitation,
  premiumReferral,
  issuerReferral,
  unknown,
}

class BranchRegistrationReferral {
  const BranchRegistrationReferral({
    this.issuerCode,
    this.memberReferralCode,
    this.memberPremiumCode,
    this.discoveryInvitationCode,
    this.campaign,
    this.invitationName,
    this.campaignPublicId,
    this.communityGroupPublicId,
    this.assignmentPublicId,
    this.invitationPublicId,
    this.type = BranchReferralType.unknown,
    this.hasDiscoveryCodeDiscrepancy = false,
    this.isDirectIssuerRegistration = false,
  });

  final String? issuerCode;
  final String? memberReferralCode;
  final String? memberPremiumCode;
  final String? discoveryInvitationCode;
  final String? campaign;
  final String? invitationName;
  final String? campaignPublicId;
  final String? communityGroupPublicId;
  final String? assignmentPublicId;
  final String? invitationPublicId;
  final BranchReferralType type;
  final bool hasDiscoveryCodeDiscrepancy;
  final bool isDirectIssuerRegistration;

  bool get isDiscoveryInvitation =>
      type == BranchReferralType.discoveryInvitation;

  bool get hasRegistrationCode =>
      issuerCode != null ||
      memberReferralCode != null ||
      memberPremiumCode != null ||
      discoveryInvitationCode != null;

  factory BranchRegistrationReferral.fromPayload(Map<dynamic, dynamic> data) {
    final directIssuerCode = data['+clicked_branch_link'] == false
        ? _directIssuerCode(data['+non_branch_link'])
        : null;
    if (directIssuerCode != null) {
      return BranchRegistrationReferral(
        issuerCode: directIssuerCode,
        type: BranchReferralType.directIssuer,
        isDirectIssuerRegistration: true,
      );
    }

    final refType = _nonEmptyString(data['ref_type'])?.toLowerCase();
    final refCode = _nonEmptyString(data['ref_code']);
    final registrationCode = _nonEmptyString(data['registrationCode']);
    final clicked = data['+clicked_branch_link'] == true;
    final feature = _nonEmptyString(data['feature'])?.toLowerCase();

    if (clicked &&
        refType == 'campaign_invitation' &&
        (feature == 'discovery-membership' ||
            (feature == null && registrationCode == null)) &&
        (registrationCode != null || refCode != null)) {
      return BranchRegistrationReferral(
        discoveryInvitationCode: registrationCode ?? refCode,
        memberReferralCode: _nonEmptyString(data['memberReferralCode']),
        campaign: _nonEmptyString(data['campaign']) ??
            _nonEmptyString(data['~campaign']),
        invitationName: _nonEmptyString(data['invitationName']),
        campaignPublicId: _nonEmptyString(data['campaignPublicId']),
        communityGroupPublicId: _nonEmptyString(data['communityGroupPublicId']),
        assignmentPublicId: _nonEmptyString(data['assignmentPublicId']),
        invitationPublicId: _nonEmptyString(data['invitationPublicId']),
        type: BranchReferralType.discoveryInvitation,
        hasDiscoveryCodeDiscrepancy: registrationCode != null &&
            refCode != null &&
            registrationCode.toUpperCase() != refCode.toUpperCase(),
      );
    }

    if (refCode != null && (refType == 'issuer' || refType == 'merchant')) {
      return BranchRegistrationReferral(
        issuerCode: refCode,
        campaign: _nonEmptyString(data['~campaign']),
        type: BranchReferralType.issuerReferral,
      );
    }

    if (refCode != null &&
        (refType == 'member' || refType == 'member_invitation')) {
      return BranchRegistrationReferral(
        memberReferralCode: refCode,
        campaign: _nonEmptyString(data['~campaign']),
        type: BranchReferralType.memberInvitation,
      );
    }

    final memberPremiumCode = _nonEmptyString(data['memberPremiumCode']);
    final memberReferralCode = _nonEmptyString(data['memberReferralCode']);
    final legacyDiscoveryCode =
        _nonEmptyString(data['discoveryInvitationCode']);
    return BranchRegistrationReferral(
      issuerCode: _nonEmptyString(data['issuercode']),
      memberReferralCode: memberReferralCode,
      memberPremiumCode: memberPremiumCode,
      discoveryInvitationCode: legacyDiscoveryCode,
      campaign: _nonEmptyString(data['~campaign']),
      type: memberPremiumCode != null
          ? BranchReferralType.premiumReferral
          : memberReferralCode != null
              ? BranchReferralType.memberInvitation
              : legacyDiscoveryCode != null
                  ? BranchReferralType.discoveryInvitation
                  : BranchReferralType.unknown,
    );
  }

  static bool isUnresolvedTrustedShortLinkPayload(
    Map<dynamic, dynamic> data,
  ) {
    if (data['+clicked_branch_link'] != false) return false;

    final rawLink = _nonEmptyString(data['+non_branch_link']);
    final uri = rawLink == null ? null : Uri.tryParse(rawLink);
    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.toLowerCase() != 'app.touristsaver.org' ||
        uri.hasPort ||
        uri.path == '/register' ||
        uri.pathSegments.length != 1) {
      return false;
    }

    return RegExp(r'^[A-Za-z0-9_-]{6,}$').hasMatch(uri.pathSegments.single);
  }

  Map<String, dynamic> toJson() => {
        'discoveryInvitationCode': discoveryInvitationCode,
        'memberReferralCode': memberReferralCode,
        'campaign': campaign,
        'invitationName': invitationName,
        'campaignPublicId': campaignPublicId,
        'communityGroupPublicId': communityGroupPublicId,
        'assignmentPublicId': assignmentPublicId,
        'invitationPublicId': invitationPublicId,
        'type': type.name,
        'hasDiscoveryCodeDiscrepancy': hasDiscoveryCodeDiscrepancy,
      };

  factory BranchRegistrationReferral.fromJson(Map<String, dynamic> json) {
    final typeName = _nonEmptyString(json['type']);
    final type = BranchReferralType.values.firstWhere(
      (candidate) => candidate.name == typeName,
      orElse: () => BranchReferralType.unknown,
    );
    return BranchRegistrationReferral(
      discoveryInvitationCode: _nonEmptyString(json['discoveryInvitationCode']),
      memberReferralCode: _nonEmptyString(json['memberReferralCode']),
      campaign: _nonEmptyString(json['campaign']),
      invitationName: _nonEmptyString(json['invitationName']),
      campaignPublicId: _nonEmptyString(json['campaignPublicId']),
      communityGroupPublicId: _nonEmptyString(json['communityGroupPublicId']),
      assignmentPublicId: _nonEmptyString(json['assignmentPublicId']),
      invitationPublicId: _nonEmptyString(json['invitationPublicId']),
      type: type,
      hasDiscoveryCodeDiscrepancy: json['hasDiscoveryCodeDiscrepancy'] == true,
    );
  }

  static String? _directIssuerCode(dynamic link) {
    final rawLink = _nonEmptyString(link);
    final uri = rawLink == null ? null : Uri.tryParse(rawLink);
    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.toLowerCase() != 'app.touristsaver.org' ||
        uri.hasPort ||
        uri.path != '/register') {
      return null;
    }

    for (final parameter in uri.queryParameters.entries) {
      if (parameter.key.toLowerCase() == 'issuercode') {
        return _nonEmptyString(parameter.value);
      }
    }
    return null;
  }

  static String? _nonEmptyString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    if (result.isEmpty || result.toLowerCase() == 'null') return null;
    return result;
  }
}

Map<String, String> registrationQueryParametersFor(
  BranchRegistrationReferral? referral,
) {
  return {
    'issuercode': referral?.issuerCode ?? '',
    'memberReferralCode': referral?.memberReferralCode ?? '',
    'memberPremiumCode': referral?.memberPremiumCode ?? '',
    'discoveryInvitationCode': referral?.isDiscoveryInvitation == true
        ? ''
        : referral?.discoveryInvitationCode ?? '',
    'registrationCode': referral?.isDiscoveryInvitation == true
        ? referral?.discoveryInvitationCode ?? ''
        : '',
    'recognizedDiscoveryInvitation':
        referral?.isDiscoveryInvitation == true ? 'true' : '',
  };
}

bool shouldOpenDiscoveryIntro({
  required String? authToken,
  required String currentPath,
}) {
  if (authToken?.trim().isNotEmpty == true) return false;
  const registrationJourneyPaths = {
    '/intro-screen',
    '/membership-country',
    '/register',
    '/number-reg-otp',
  };
  return !registrationJourneyPaths.contains(currentPath);
}

class BranchReferralService {
  BranchReferralService._();

  static final StreamController<BranchRegistrationReferral> _controller =
      StreamController<BranchRegistrationReferral>.broadcast();
  static final StreamController<BranchRegistrationReferral>
      _directIssuerController =
      StreamController<BranchRegistrationReferral>.broadcast();
  static final StreamController<BranchRegistrationReferral>
      _discoveryController =
      StreamController<BranchRegistrationReferral>.broadcast();
  static final StreamController<void> _unavailableInvitationController =
      StreamController<void>.broadcast();

  static StreamSubscription<Map>? _branchSubscription;
  static BranchRegistrationReferral? _pendingReferral;
  static BranchRegistrationReferral? _pendingDirectIssuerReferral;
  static BranchRegistrationReferral? _pendingDiscoveryReferral;
  static bool _pendingUnavailableInvitationNotice = false;

  static Stream<BranchRegistrationReferral> get referrals => _controller.stream;
  static Stream<BranchRegistrationReferral> get directIssuerReferrals =>
      _directIssuerController.stream;
  static Stream<BranchRegistrationReferral> get discoveryReferrals =>
      _discoveryController.stream;
  static Stream<void> get unavailableInvitationLinks =>
      _unavailableInvitationController.stream;
  static BranchRegistrationReferral? get pendingReferral => _pendingReferral;
  static BranchRegistrationReferral? get pendingDirectIssuerReferral =>
      _pendingDirectIssuerReferral;
  static BranchRegistrationReferral? get pendingDiscoveryReferral =>
      _pendingDiscoveryReferral;
  static bool get hasPendingRegistrationReferral =>
      _pendingDiscoveryReferral != null ||
      _pendingReferral?.hasRegistrationCode == true;

  static Future<void> restorePendingDiscoveryReferral() async {
    final raw = await Pref().readData(
      key: pendingDiscoveryRegistrationReferralKey,
    );
    if (raw == null || raw.toString().trim().isEmpty) return;
    try {
      final decoded = jsonDecode(raw.toString());
      if (decoded is! Map) return;
      final referral = BranchRegistrationReferral.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      if (referral.isDiscoveryInvitation &&
          referral.discoveryInvitationCode != null) {
        _pendingDiscoveryReferral = referral;
      }
    } catch (_) {
      await Pref().removeData(pendingDiscoveryRegistrationReferralKey);
    }
  }

  static void start() {
    if (_branchSubscription != null) return;

    _branchSubscription = FlutterBranchSdk.listSession().listen(
      (data) async {
        if (await handleUnresolvedInvitationLinkPayload(data)) return;

        final referral = BranchRegistrationReferral.fromPayload(data);
        if (referral.isDirectIssuerRegistration) {
          _pendingDirectIssuerReferral = referral;
          _directIssuerController.add(referral);
          return;
        }

        if (data['+clicked_branch_link'] == true &&
            referral.isDiscoveryInvitation) {
          if (!_sameDiscoveryCode(_pendingDiscoveryReferral, referral)) {
            _pendingDiscoveryReferral = referral;
            unawaited(_persistPendingDiscoveryReferral(referral));
            _discoveryController.add(referral);
          }
          return;
        }

        if (data['+clicked_branch_link'] != true) return;

        if (!referral.hasRegistrationCode) return;
        _pendingReferral = referral;
        _controller.add(referral);
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('BRANCH_ERROR: $error');
      },
    );
  }

  static BranchRegistrationReferral? takePendingReferral() {
    final referral = _pendingReferral;
    _pendingReferral = null;
    return referral;
  }

  static void markHandled(BranchRegistrationReferral referral) {
    if (identical(_pendingReferral, referral)) {
      _pendingReferral = null;
    }
  }

  static void markDirectIssuerHandled(BranchRegistrationReferral referral) {
    if (identical(_pendingDirectIssuerReferral, referral)) {
      _pendingDirectIssuerReferral = null;
    }
  }

  static Future<bool> handleUnresolvedInvitationLinkPayload(
    Map<dynamic, dynamic> data,
  ) async {
    if (!BranchRegistrationReferral.isUnresolvedTrustedShortLinkPayload(data)) {
      return false;
    }

    if (_pendingReferral?.isDiscoveryInvitation == true) {
      _pendingReferral = null;
    }
    await clearPendingDiscoveryReferral();
    _pendingUnavailableInvitationNotice = true;
    _unavailableInvitationController.add(null);
    return true;
  }

  static bool takePendingUnavailableInvitationNotice() {
    if (!_pendingUnavailableInvitationNotice) return false;
    _pendingUnavailableInvitationNotice = false;
    return true;
  }

  static Future<void> replacePendingDiscoveryReferral(
    BranchRegistrationReferral referral,
  ) async {
    if (!referral.isDiscoveryInvitation ||
        referral.discoveryInvitationCode == null) {
      return;
    }
    _pendingDiscoveryReferral = referral;
    await _persistPendingDiscoveryReferral(referral);
  }

  static Future<void> clearPendingDiscoveryReferral({String? code}) async {
    final pendingCode = _pendingDiscoveryReferral?.discoveryInvitationCode;
    if (code != null &&
        pendingCode != null &&
        pendingCode.toUpperCase() != code.toUpperCase()) {
      return;
    }
    _pendingDiscoveryReferral = null;
    await Pref().removeData(pendingDiscoveryRegistrationReferralKey);
  }

  @visibleForTesting
  static void resetPendingDiscoveryInMemory() {
    _pendingDiscoveryReferral = null;
  }

  static bool _sameDiscoveryCode(
    BranchRegistrationReferral? left,
    BranchRegistrationReferral right,
  ) =>
      left?.discoveryInvitationCode?.toUpperCase() ==
      right.discoveryInvitationCode?.toUpperCase();

  static Future<void> _persistPendingDiscoveryReferral(
    BranchRegistrationReferral referral,
  ) =>
      Pref().writeData(
        key: pendingDiscoveryRegistrationReferralKey,
        value: jsonEncode(referral.toJson()),
      );
}
