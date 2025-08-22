import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class StateAllEvent extends Equatable {
  const StateAllEvent();
}

class LoadStateAllEvent extends StateAllEvent {
  @override
  List<Object> get props => [];
}
