import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/response/merchant_get_my_wallet.dart';
import '../../../models/response/universal_get_my_wallet.dart';

@immutable
abstract class ProfileWalletState extends Equatable {}

// data loading state
class ProfileWalletLoadingState extends ProfileWalletState {
  @override
  List<Object?> get props => [];
}

// data loaded state
class ProfileWalletLoadedState extends ProfileWalletState {
  ProfileWalletLoadedState({this.universalWallet, this.merchantWallet});

  final UniversalGetMyWallet? universalWallet;
  final MerchantGetMyWallet? merchantWallet;

  @override
  List<Object?> get props => [universalWallet, merchantWallet];
}

// data error loading state
class ProfileWalletErrorState extends ProfileWalletState {
  ProfileWalletErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
