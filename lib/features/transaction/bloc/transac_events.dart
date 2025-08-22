import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class TransacEvent extends Equatable {
  const TransacEvent();
}

class LoadTransacEvent extends TransacEvent {
  @override
  List<Object> get props => [];
}
