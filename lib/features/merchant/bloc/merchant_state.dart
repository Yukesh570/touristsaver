part of 'merchant_bloc.dart';

abstract class MerchantState extends Equatable {
  const MerchantState();

  @override
  List<Object> get props => [];
}

class MerchantInitialState extends MerchantState {}

class FavoriteLoadingState extends MerchantState {}

class FavoriteLoadedState extends MerchantState {}
