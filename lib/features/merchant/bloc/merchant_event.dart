part of 'merchant_bloc.dart';

abstract class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteLoadingEvent extends MerchantEvent {
  const FavoriteLoadingEvent();
}

class FavoriteLoadedEvent extends MerchantEvent {
  const FavoriteLoadedEvent();
}
