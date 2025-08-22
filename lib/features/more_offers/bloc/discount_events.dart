import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class MerchantDiscountEvent extends Equatable {
  const MerchantDiscountEvent();
}

class LoadMerchantDiscountEvent extends MerchantDiscountEvent {
  @override
  List<Object> get props => [];
}
