import 'dart:async';

import 'package:daily_routine/blocs/credits_event.dart';
import 'package:daily_routine/blocs/credits_state.dart';
import 'package:daily_routine/repositories/credits_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreditsBloc extends Bloc<CreditsEvent, CreditsState> {
  final CreditsRepository repository;

  CreditsBloc({required this.repository}) : super(CreditsInitial()) {
    on<GetCreditsEvent>(_onGetCredits);
  }

  FutureOr<void> _onGetCredits(GetCreditsEvent event, Emitter<CreditsState> emit) {
    emit(CurrentAmountCreditsState(credits: repository.credits));
  }
}