import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LocationAllEvent extends Equatable {
  const LocationAllEvent();
}

class LoadLocationAllEvent extends LocationAllEvent {
  @override
  List<Object> get props => [];
}
