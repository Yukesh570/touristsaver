import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

@immutable
abstract class AgreementEvent extends Equatable {
  const AgreementEvent();
}

class LoadAgreementEvent extends AgreementEvent {
  @override
  List<Object> get props => [];
}
