import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/response/universal_get_my_wallet.dart';

@immutable
abstract class WalletState extends Equatable {}

// data loading state
class WalletLoadingState extends WalletState {
  @override
  List<Object?> get props => [];
}

// data loaded state
class WalletLoadedState extends WalletState {
  WalletLoadedState(this.walletRes);
  final UniversalGetMyWallet walletRes;
  @override
  List<Object?> get props => [walletRes];
}

// data error loading state
class WalletErrorState extends WalletState {
  WalletErrorState(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
