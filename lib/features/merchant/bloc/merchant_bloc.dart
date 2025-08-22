import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'merchant_event.dart';
part 'merchant_state.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitialState()) {
    on<FavoriteLoadingEvent>(_onFavoriteLoadingCalled);
    on<FavoriteLoadedEvent>(_onFavoriteLoadedCalled);
  }

  void _onFavoriteLoadingCalled(
      FavoriteLoadingEvent event, Emitter<MerchantState> emit) {
    emit(FavoriteLoadingState());
  }

  void _onFavoriteLoadedCalled(
      FavoriteLoadedEvent event, Emitter<MerchantState> emit) {
    emit(FavoriteLoadedState());
  }
}
