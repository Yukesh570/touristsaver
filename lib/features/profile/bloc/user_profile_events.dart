import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class LoadUserProfileEvent extends UserProfileEvent {
  @override
  List<Object> get props => [];
}
