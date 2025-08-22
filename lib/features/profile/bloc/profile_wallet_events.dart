import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileWalletEvent extends Equatable {
  const ProfileWalletEvent();
}

class GetUniversalUserWalletEvent extends ProfileWalletEvent {
  @override
  List<Object> get props => [];
}

class GetMerchantUserWalletEvent extends ProfileWalletEvent {
  @override
  List<Object> get props => [];
}
