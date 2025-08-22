import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class MerchantDetailEvent extends Equatable {
  const MerchantDetailEvent();
}

class LoadMerchantDetailEvent extends MerchantDetailEvent {
  @override
  List<Object> get props => [];
}

class AddFavoriteMerchantEvent extends MerchantDetailEvent {
  const AddFavoriteMerchantEvent(this.merchantId);

  final int merchantId;

  @override
  List<Object?> get props => [];
}
