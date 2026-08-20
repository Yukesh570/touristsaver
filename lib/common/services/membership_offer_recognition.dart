import 'package:intl/intl.dart' show DateFormat;
import 'package:touristsaver/common/services/dio_common.dart';
import 'package:touristsaver/features/details/services/dio_detail.dart';
import 'package:touristsaver/models/response/membership_offer_code_details.dart';

class PremiumWelcomeRecognition {
  const PremiumWelcomeRecognition({
    this.isComplimentary = false,
    this.sourceName,
    this.proudlySupportsSource = false,
  });

  final bool isComplimentary;
  final String? sourceName;
  final bool proudlySupportsSource;
}

bool shouldLoadLegacyMerchantAttribution({
  required String? codeOwnerType,
  required int? codeOwnerId,
  required String? assignedToName,
}) =>
    codeOwnerType?.trim().toLowerCase() == 'merchant' &&
    codeOwnerId != null &&
    assignedToName?.trim().isNotEmpty != true;

class MembershipOfferRecognition {
  Future<PremiumWelcomeRecognition> fromCurrentMember() async {
    try {
      final response = await DioCommon().getdiscountInmemberPremiumCode();
      final rawData = response is Map ? response['data'] : null;
      return fromCodeData(rawData);
    } catch (_) {
      return const PremiumWelcomeRecognition();
    }
  }

  Future<PremiumWelcomeRecognition> fromCodeData(dynamic rawData) async {
    if (rawData is! Map) return const PremiumWelcomeRecognition();

    final offer = MembershipOfferCodeDetails.fromJson(
      Map<String, dynamic>.from(rawData),
    );
    String? sourceName = offer.assignedToName;

    if (shouldLoadLegacyMerchantAttribution(
      codeOwnerType: offer.codeOwnerType,
      codeOwnerId: offer.codeOwnerId,
      assignedToName: sourceName,
    )) {
      final now = DateTime.now();
      final merchant = await DioDetail().getMerchantDetail(
        id: offer.codeOwnerId!,
        day: DateFormat('EEEE').format(now),
        hour: now.hour,
      );
      final merchantName = merchant?.data?.merchantName?.trim();
      if (merchantName?.isNotEmpty == true) sourceName = merchantName;
    }

    return PremiumWelcomeRecognition(
      isComplimentary: offer.isComplimentaryMembership,
      sourceName:
          sourceName?.trim().isNotEmpty == true ? sourceName!.trim() : null,
      proudlySupportsSource: offer.proudlySupportsSource,
    );
  }
}
