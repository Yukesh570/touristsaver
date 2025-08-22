import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
abstract class AllCharityListEvent extends Equatable {
  const AllCharityListEvent();
}

class LoadAllCharityListEvent extends AllCharityListEvent {
  @override
  List<Object> get props => [];
}
