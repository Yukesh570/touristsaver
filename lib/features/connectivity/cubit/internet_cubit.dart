import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectivityState { connected, disconnected, loading }

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  //  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];

  ConnectivityCubit() : super(ConnectivityState.loading) {
    // Listen to app lifecycle changes
    _monitorConnectivity();
  }

  // Monitor connectivity changes when the app is in the foreground
  void _monitorConnectivity() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // log("Result Monitor: ${result.toList().toString()}");
      if (result.contains(ConnectivityResult.none)) {
        emit(ConnectivityState.disconnected);
      } else {
        emit(ConnectivityState.connected);
      }
    });
  }

  // Initial manual check for connection status
  Future<void> checkConnectivity() async {
    emit(ConnectivityState.loading);
    var result = await _connectivity.checkConnectivity();
    // log("Result check: ${result.toList().toString()}");
    if (result.contains(ConnectivityResult.none)) {
      emit(ConnectivityState.disconnected);
    } else {
      emit(ConnectivityState.connected);
    }
  }

  // Cancel the subscription when the cubit is closed
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}



// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'internet_state.dart';

// class InternetCubit extends Cubit<InternetStatus> {
//   InternetCubit()
//       : super(const InternetStatus(ConnectivityStatus.disconnected));

//   void checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     _updateConnectivityStatus(connectivityResult);
//   }

//   _updateConnectivityStatus(ConnectivityResult result) {
//     if (result == ConnectivityResult.none) {
//       emit(const InternetStatus(ConnectivityStatus.disconnected));
//     } else {
//       emit(const InternetStatus(ConnectivityStatus.connected));
//     }
//   }

//   late StreamSubscription<ConnectivityResult?> _subscription;

//   void trackConnectivityChange() {
//     _subscription = Connectivity().onConnectivityChanged.listen((result) {
//       _updateConnectivityStatus(result);
//     });
//   }

//   void dispose() {
//     _subscription.cancel();
//   }
// }


///

// class InternetCubit extends Cubit<bool> {
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;

//   InternetCubit() : super(false) {
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }
//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     bool isConnected = result != ConnectivityResult.none;
//     emit(isConnected);
//   }

//   @override
//   Future<void> close() {
//     _connectivitySubscription.cancel();
//     return super.close();
//   }
// }
