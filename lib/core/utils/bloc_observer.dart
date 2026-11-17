import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logWarning(event.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logWarning(
      '${bloc.runtimeType} Change { currentState: ${change.currentState}, nextState: ${change.nextState} }',
    );
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logWarning(bloc.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logWarning(transition.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logError(error.toString());
    super.onError(bloc, error, stackTrace);
  }
}
