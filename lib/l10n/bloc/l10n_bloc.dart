// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'l10n_event.dart';
// part 'l10n_state.dart';

// class L10nBloc extends Bloc<L10nEvent, L10nState> {
//   L10nBloc() : super(L10nInitialState()) {
//     on<L10nEvent>((event, emit) {
//       emit(L10nLoadingState());
//       try {
//         //  final lang = await DioLang.getLang();
//         emit(L10nLoadedState(lang!));
//       } catch (e) {
//         emit(L10nErrorState(e.toString()));
//         // print(e.toString());
//       }
//     });
//   }
// }
