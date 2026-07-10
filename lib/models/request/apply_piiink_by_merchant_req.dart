class ApplyPiiinkByMerchantReqModel {
  const ApplyPiiinkByMerchantReqModel({
    required this.merchantId,
    required this.amount,
    this.lang,
  });

  final int merchantId;
  final double amount;
  final String? lang;

  Map<String, dynamic> toJson() => {
        'merchantId': merchantId,
        'amount': amount,
        'lang': lang,
      };
}
