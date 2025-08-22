import 'dart:convert';

SearchMerchantResModel searchMerchantResModelFromJson(String str) =>
    SearchMerchantResModel.fromJson(json.decode(str));

class SearchMerchantResModel {
  SearchMerchantResModel({
    this.status,
    this.merchantCategories,
    this.merchants,
  });

  final String? status;
  final List<MerchantCategory>? merchantCategories;
  final List<Merchant>? merchants;

  factory SearchMerchantResModel.fromJson(Map<String, dynamic> json) =>
      SearchMerchantResModel(
        status: json["status"],
        merchantCategories: json["merchantCategories"] == null
            ? null
            : List<MerchantCategory>.from(json["merchantCategories"]
                .map((x) => MerchantCategory.fromJson(x))),
        merchants: json["merchants"] == null
            ? null
            : List<Merchant>.from(
                json["merchants"].map((x) => Merchant.fromJson(x))),
      );
}

class MerchantCategory {
  MerchantCategory({
    this.id,
    this.name,
    this.imageName,
    this.slug,
    this.priorityOrder,
    this.isVisibleOnApp,
    this.subCategoryLevel,
    this.createdAt,
    this.parentId,
  });

  final int? id;
  final String? name;
  final String? imageName;
  final String? slug;
  final int? priorityOrder;
  final bool? isVisibleOnApp;
  final int? subCategoryLevel;
  final DateTime? createdAt;
  final dynamic parentId;

  factory MerchantCategory.fromJson(Map<String, dynamic> json) =>
      MerchantCategory(
        id: json["id"],
        name: json["name"],
        imageName: json["imageName"],
        slug: json["slug"],
        priorityOrder: json["priorityOrder"],
        isVisibleOnApp: json["isVisibleOnApp"],
        subCategoryLevel: json["subCategoryLevel"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        parentId: json["parentId"],
      );
}

class Merchant {
  Merchant({
    this.id,
    this.merchantName,
    this.maxDiscount,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.merchantEmail,
    this.merchantPhoneNumber,
    this.email,
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
    this.transactionCode,
    this.isPopularFlag,
    this.popularOrder,
    this.agreedTermAndCondition,
    this.isImported,
    this.emailSent,
    this.createdAt,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.postalCodeUser,
    this.postalCodeId,
    this.memberAsRefererId,
    this.whiteLabelId,
    this.merchantPackageId,
    this.isPremium,
    this.packageExpirydate,
    this.signerId,
    this.signerType,
    this.charityId,
    this.merchantImageInfo,
    this.favoriteMerchant,
  });

  final int? id;
  final String? merchantName;
  final double? maxDiscount;
  final String? contactPersonFirstName;
  final String? contactPersonLastName;
  final String? merchantEmail;
  final String? merchantPhoneNumber;
  final String? email;
  final dynamic stripeSubscriptionId;
  final dynamic stripeCustomerId;
  final String? phoneNumber;
  final String? businessRegistrationNumber;
  final List<double>? latlon;
  final String? buildingNo;
  final String? streetInfo;
  final dynamic city;
  final bool? registrationIsComplete;
  final bool? isAgreementComplete;
  final int? registrationCompletedStep;
  final dynamic rejectReason;
  final String? registrationStatus;
  final String? transactionCode;
  final bool? isPopularFlag;
  final dynamic popularOrder;
  final bool? agreedTermAndCondition;
  final bool? isImported;
  final bool? emailSent;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final dynamic postalCodeUser;
  final int? postalCodeId;
  final dynamic memberAsRefererId;
  final dynamic whiteLabelId;
  final int? merchantPackageId;
  final bool? isPremium;
  final dynamic packageExpirydate;
  final int? signerId;
  final String? signerType;
  final int? charityId;
  final MerchantImageInfo? merchantImageInfo;
  final FavoriteMerchant? favoriteMerchant;

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: json["id"],
        merchantName: json["merchantName"],
        maxDiscount: json["maxDiscount"]?.toDouble(),
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        merchantEmail: json["merchantEmail"],
        merchantPhoneNumber: json["merchantPhoneNumber"],
        email: json["email"],
        stripeSubscriptionId: json["stripeSubscriptionId"],
        stripeCustomerId: json["stripeCustomerId"],
        phoneNumber: json["phoneNumber"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        latlon: json["latlon"] == null
            ? null
            : List<double>.from(json["latlon"].map((x) => x.toDouble())),
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        city: json["city"],
        registrationIsComplete: json["registrationIsComplete"],
        isAgreementComplete: json["isAgreementComplete"],
        registrationCompletedStep: json["registrationCompletedStep"],
        rejectReason: json["rejectReason"],
        registrationStatus: json["registrationStatus"],
        transactionCode: json["transactionCode"],
        isPopularFlag: json["isPopularFlag"],
        popularOrder: json["popularOrder"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        isImported: json["isImported"],
        emailSent: json["emailSent"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        postalCodeUser: json["postalCodeUser"],
        postalCodeId: json["postalCodeId"],
        memberAsRefererId: json["memberAsRefererId"],
        whiteLabelId: json["whiteLabelId"],
        merchantPackageId: json["merchantPackageId"],
        isPremium: json["isPremium"],
        packageExpirydate: json["packageExpirydate"],
        signerId: json["signerId"],
        signerType: json["signerType"],
        charityId: json["charityId"],
        merchantImageInfo: json["__merchantImageInfo__"] == null
            ? null
            : MerchantImageInfo.fromJson(json["__merchantImageInfo__"]),
        favoriteMerchant: json["favoriteMerchant"] == null
            ? null
            : FavoriteMerchant.fromJson(json),
      );
}

class MerchantImageInfo {
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

  final int? id;
  final String? logoUrl;
  final String? slider1;
  final String? slider2;
  final String? slider3;
  final String? slider4;
  final String? slider5;
  final String? slider6;
  final DateTime? createdAt;
  final int? merchantId;

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

class FavoriteMerchant {
  final int? id;

  FavoriteMerchant({
    this.id,
  });

  factory FavoriteMerchant.fromJson(Map<String, dynamic> json) =>
      FavoriteMerchant(
        id: json["id"],
      );
}
