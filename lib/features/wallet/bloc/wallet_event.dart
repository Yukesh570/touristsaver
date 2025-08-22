import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class WalletEvent extends Equatable {
  const WalletEvent();
}

class LoadWalletEvent extends WalletEvent {
  @override
  List<Object> get props => [];
}
