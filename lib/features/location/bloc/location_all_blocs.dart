import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_piiink/features/location/bloc/location_all_events.dart';
import 'package:new_piiink/features/location/bloc/location_all_states.dart';
import 'package:new_piiink/features/location/services/dio_location.dart';

import '../../register/services/dio_register.dart';

class LocationAllBloc extends Bloc<LocationAllEvent, LocationAllState> {
  final DioLocation dioLocation;

  LocationAllBloc(this.dioLocation) : super(LocationAllLoadingState()) {
    on<LocationAllEvent>((event, emit) async {
      emit(LocationAllLoadingState());
      try {
        final locationGetAll = await dioLocation.getAllLocation();
        final phonePrefix = await DioRegister().countryPhonePrefix();
        emit(LocationAllLoadedState(locationGetAll!, phonePrefix!));
      } catch (e) {
        emit(LocationAllErrorState(e.toString()));
        // print(e.toString());
      }
    });
  }
}
