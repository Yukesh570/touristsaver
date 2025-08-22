import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class LoadCategoryEvent extends CategoryEvent {
  final String? lang;
  const LoadCategoryEvent(this.lang);
  @override
  List<Object> get props => [lang!];
}
