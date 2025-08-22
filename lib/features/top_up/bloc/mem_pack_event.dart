import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MemPackAllEvent extends Equatable {
  const MemPackAllEvent();
}

class LoadMemPackAllEvent extends MemPackAllEvent {
  @override
  List<Object> get props => [];
}
