// import 'package:async/async.dart';

// class InactivityManager {
//   late Function() onInactivityCallback;
//   late RestartableTimer? _timer;

//   static final InactivityManager instance = InactivityManager._internal();

//   InactivityManager._internal();

//   factory InactivityManager({required Function() callback}) {
//     instance.onInactivityCallback = callback;
//     return instance;
//   }

//   void start() {
//     _timer = RestartableTimer(const Duration(seconds: 5), () {
//       onInactivityCallback();
//     });
//   }

//   void reset() => _timer?.reset();
//   bool isActive() => _timer?.isActive ?? false;
// }
