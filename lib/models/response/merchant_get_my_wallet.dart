import 'dart:convert';

MerchantGetMyWallet merchantGetMyWalletFromJson(String str) =>
    MerchantGetMyWallet.fromJson(json.decode(str));

class MerchantGetMyWallet {
  String? status;
  Data? data;

  MerchantGetMyWallet({
    this.status,
    this.data,
  });

  factory MerchantGetMyWallet.fromJson(Map<String, dynamic> json) =>
      MerchantGetMyWallet(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<MerchantWallet>? merchantWallet;
  List<MerchantWallet>? merchantFranchiseWallet;

  Data({
    this.merchantWallet,
    this.merchantFranchiseWallet,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        merchantWallet: json["MerchantWallet"] == null
            ? []
            : List<MerchantWallet>.from(
                json["MerchantWallet"]!.map((x) => MerchantWallet.fromJson(x))),
        merchantFranchiseWallet: json["MerchantFranchiseWallet"] == null
            ? []
            : List<MerchantWallet>.from(json["MerchantFranchiseWallet"]!
                .map((x) => MerchantWallet.fromJson(x))),
      );
}

class MerchantWallet {
  int? id;
  double? balance;
  DateTime? createdAt;
  int? memberId;
  int? merchantId;
  String? merchantType;
  int? countryId;
  Merchant? merchant;
  MerchantImageInfo? merchantImageInfo;

  MerchantWallet({
    this.id,
    this.balance,
    this.createdAt,
    this.memberId,
    this.merchantId,
    this.merchantType,
    this.countryId,
    this.merchant,
    this.merchantImageInfo,
  });

  factory MerchantWallet.fromJson(Map<String, dynamic> json) => MerchantWallet(
        id: json["id"],
        balance: json["balance"]?.toDouble(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        memberId: json["memberId"],
        merchantId: json["merchantId"],
        merchantType: json["merchantType"],
        countryId: json["countryId"],
        merchant: json["__merchant__"] == null
            ? null
            : Merchant.fromJson(json["__merchant__"]),
        merchantImageInfo: json["__merchantImageInfo__"] == null
            ? null
            : MerchantImageInfo.fromJson(json["__merchantImageInfo__"]),
      );
}

class Merchant {
  int? id;
  String? logoUrl;
  String? merchantEcommerceKey;
  String? merchantName;
  dynamic maxDiscount;
  String? contactPersonFirstName;
  String? contactPersonLastName;
  String? merchantEmail;
  String? merchantPhoneNumber;
  String? username;
  String? email;
  int? transactionFeePercentage;
  String? stripeSubscriptionId;
  String? stripeCustomerId;
  String? phoneNumber;
  String? businessRegistrationNumber;
  List<double>? latlon;
  String? buildingNo;
  String? streetInfo;
  String? city;
  bool? registrationIsComplete;
  bool? isAgreementComplete;
  int? registrationCompletedStep;
  dynamic rejectReason;
  String? registrationStatus;
  String? merchantStatus;
  bool? merchantEmailSentFromDraft;
  String? transactionCode;
  bool? isApproved;
  bool? isActive;
  bool? isPopularFlag;
  int? popularOrder;
  bool? agreedTermAndCondition;
  bool? isImported;
  bool? emailSent;
  bool? mailSentBySigner;
  bool? referredFromLink;
  DateTime? createdAt;
  DateTime? approvedDate;
  DateTime? verifiedDate;
  DateTime? savedDate;
  int? countryId;
  int? stateId;
  int? regionId;
  int? areaId;
  String? postalCodeUser;
  int? postalCodeId;
  dynamic memberAsRefererId;
  int? whiteLabelId;
  int? merchantPackageId;
  bool? isPremiumFrombeginning;
  bool? isPremium;
  bool? isCreatedByAdmin;
  DateTime? turnedToPremiumDate;
  DateTime? packageExpirydate;
  int? signerId;
  String? signerType;
  int? charityId;
  dynamic merchantFranchisorId;
  bool? bulkEmailSend;
  dynamic fcmNotificationKey;

  Merchant({
    this.id,
    this.logoUrl,
    this.merchantEcommerceKey,
    this.merchantName,
    this.maxDiscount,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.merchantEmail,
    this.merchantPhoneNumber,
    this.username,
    this.email,
    this.transactionFeePercentage,
    this.stripeSubscriptionId,
    this.stripeCustomerId,
    this.phoneNumber,
    this.businessRegistrationNumber,
    this.latlon,
    this.buildingNo,
    this.streetInfo,
    this.city,
    this.registrationIsComplete,
    this.isAgreementComplete,
    this.registrationCompletedStep,
    this.rejectReason,
    this.registrationStatus,
    this.merchantStatus,
    this.merchantEmailSentFromDraft,
    this.transactionCode,
    this.isApproved,
    this.isActive,
    this.isPopularFlag,
    this.popularOrder,
    this.agreedTermAndCondition,
    this.isImported,
    this.emailSent,
    this.mailSentBySigner,
    this.referredFromLink,
    this.createdAt,
    this.approvedDate,
    this.verifiedDate,
    this.savedDate,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.postalCodeUser,
    this.postalCodeId,
    this.memberAsRefererId,
    this.whiteLabelId,
    this.merchantPackageId,
    this.isPremiumFrombeginning,
    this.isPremium,
    this.isCreatedByAdmin,
    this.turnedToPremiumDate,
    this.packageExpirydate,
    this.signerId,
    this.signerType,
    this.charityId,
    this.merchantFranchisorId,
    this.bulkEmailSend,
    this.fcmNotificationKey,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: json["id"],
        logoUrl: json["logoUrl"],
        merchantEcommerceKey: json["merchantEcommerceKey"],
        merchantName: json["merchantName"],
        maxDiscount: json["maxDiscount"],
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        merchantEmail: json["merchantEmail"],
        merchantPhoneNumber: json["merchantPhoneNumber"],
        username: json["username"],
        email: json["email"],
        transactionFeePercentage: json["transactionFeePercentage"],
        stripeSubscriptionId: json["stripeSubscriptionId"],
        stripeCustomerId: json["stripeCustomerId"],
        phoneNumber: json["phoneNumber"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        latlon: json["latlon"] == null
            ? []
            : List<double>.from(json["latlon"]!.map((x) => x?.toDouble())),
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        city: json["city"],
        registrationIsComplete: json["registrationIsComplete"],
        isAgreementComplete: json["isAgreementComplete"],
        registrationCompletedStep: json["registrationCompletedStep"],
        rejectReason: json["rejectReason"],
        registrationStatus: json["registrationStatus"],
        merchantStatus: json["merchantStatus"],
        merchantEmailSentFromDraft: json["merchantEmailSentFromDraft"],
        transactionCode: json["transactionCode"],
        isApproved: json["isApproved"],
        isActive: json["isActive"],
        isPopularFlag: json["isPopularFlag"],
        popularOrder: json["popularOrder"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        isImported: json["isImported"],
        emailSent: json["emailSent"],
        mailSentBySigner: json["mailSentBySigner"],
        referredFromLink: json["referredFromLink"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        approvedDate: json["approvedDate"] == null
            ? null
            : DateTime.parse(json["approvedDate"]),
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
        savedDate: json["savedDate"] == null
            ? null
            : DateTime.parse(json["savedDate"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        postalCodeUser: json["postalCodeUser"],
        postalCodeId: json["postalCodeId"],
        memberAsRefererId: json["memberAsRefererId"],
        whiteLabelId: json["whiteLabelId"],
        merchantPackageId: json["merchantPackageId"],
        isPremiumFrombeginning: json["isPremiumFrombeginning"],
        isPremium: json["isPremium"],
        isCreatedByAdmin: json["isCreatedByAdmin"],
        turnedToPremiumDate: json["turnedToPremiumDate"] == null
            ? null
            : DateTime.parse(json["turnedToPremiumDate"]),
        packageExpirydate: json["packageExpirydate"] == null
            ? null
            : DateTime.parse(json["packageExpirydate"]),
        signerId: json["signerId"],
        signerType: json["signerType"],
        charityId: json["charityId"],
        merchantFranchisorId: json["merchantFranchisorId"],
        bulkEmailSend: json["bulkEmailSend"],
        fcmNotificationKey: json["fcmNotificationKey"],
      );
}

class MerchantImageInfo {
  int? id;
  String? logoUrl;
  String? slider1;
  String? slider2;
  String? slider3;
  String? slider4;
  String? slider5;
  String? slider6;
  DateTime? createdAt;
  int? merchantId;

  MerchantImageInfo({
    this.id,
    this.logoUrl,
    this.slider1,
    this.slider2,
    this.slider3,
    this.slider4,
    this.slider5,
    this.slider6,
    this.createdAt,
    this.merchantId,
  });

  factory MerchantImageInfo.fromJson(Map<String, dynamic> json) =>
      MerchantImageInfo(
        id: json["id"],
        logoUrl: json["logoUrl"],
        slider1: json["slider1"],
        slider2: json["slider2"],
        slider3: json["slider3"],
        slider4: json["slider4"],
        slider5: json["slider5"],
        slider6: json["slider6"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        merchantId: json["merchantId"],
      );
}
