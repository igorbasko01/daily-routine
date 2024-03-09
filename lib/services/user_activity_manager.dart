import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/credits_event.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';
import 'package:daily_routine/blocs/routine_state.dart';

class UserActivityManager {
  final RoutineBloc routineBloc;
  final CreditsBloc creditsBloc;

  UserActivityManager({required this.routineBloc, required this.creditsBloc}) {
    _subscribeToRoutineBloc();
  }

  void _subscribeToRoutineBloc() {
    routineBloc.stream.listen((state) {
      if (state is MarkedAsCompletedRoutineState) {
        _updateCredits(state.routine.credits);
      } if (state is MarkedAsIncompleteRoutineState) {
        _updateCredits(-state.routine.credits);
      }
    });
  }

  void _updateCredits(int credits) {
    if (credits > 0) {
      creditsBloc.add(AddCreditsEvent(credits));
    } else {
      creditsBloc.add(WithdrawCreditsEvent(credits.abs()));
    }
  }
}