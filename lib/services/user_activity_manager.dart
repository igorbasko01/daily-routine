import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/routine_bloc.dart';

class UserActivityManager {
  final RoutineBloc routineBloc;
  final CreditsBloc creditsBloc;

  UserActivityManager({required this.routineBloc, required this.creditsBloc}) {
    // TODO: Implement subscribing to the routineBloc routine marked completed state and use the creditsBloc to add credits.
  }
}