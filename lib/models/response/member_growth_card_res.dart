class MemberGrowthCardResModel {
  const MemberGrowthCardResModel({
    required this.status,
    required this.data,
  });

  final String? status;
  final MemberGrowthCard? data;

  factory MemberGrowthCardResModel.fromJson(Map<String, dynamic> json) {
    return MemberGrowthCardResModel(
      status: json['status'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? MemberGrowthCard.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MemberGrowthCard {
  const MemberGrowthCard({
    required this.eligible,
    required this.recognitionLevel,
    required this.title,
    required this.membersIntroduced,
    required this.activeMembers,
    required this.communitySavings,
    required this.merchantsIntroduced,
  });

  final bool eligible;
  final String? recognitionLevel;
  final String title;
  final int membersIntroduced;
  final int activeMembers;
  final CommunitySavings communitySavings;
  final int merchantsIntroduced;

  factory MemberGrowthCard.fromJson(Map<String, dynamic> json) {
    return MemberGrowthCard(
      eligible: json['eligible'] == true,
      recognitionLevel: json['recognitionLevel'] as String?,
      title: json['title'] as String? ?? 'Your Community Impact',
      membersIntroduced: _readInt(json['membersIntroduced']),
      activeMembers: _readInt(json['activeMembers']),
      communitySavings: json['communitySavings'] is Map<String, dynamic>
          ? CommunitySavings.fromJson(
              json['communitySavings'] as Map<String, dynamic>,
            )
          : const CommunitySavings(amount: 0, currency: 'AUD'),
      merchantsIntroduced: _readInt(json['merchantsIntroduced']),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class CommunitySavings {
  const CommunitySavings({
    required this.amount,
    required this.currency,
  });

  final num amount;
  final String currency;

  factory CommunitySavings.fromJson(Map<String, dynamic> json) {
    return CommunitySavings(
      amount: json['amount'] is num
          ? json['amount'] as num
          : num.tryParse('${json['amount']}') ?? 0,
      currency: json['currency'] as String? ?? 'AUD',
    );
  }
}
