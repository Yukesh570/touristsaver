import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SliderEvent extends Equatable {
  const SliderEvent();
}

class LoadSliderEvent extends SliderEvent {
  @override
  List<Object> get props => [];
}
