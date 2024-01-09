import 'dart:async';

import 'package:daily_routine/blocs/credits_event.dart';
import 'package:daily_routine/blocs/credits_state.dart';
import 'package:daily_routine/repositories/credits_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreditsBloc extends Bloc<CreditsEvent, CreditsState> {
  final CreditsRepository repository;

  CreditsBloc({required this.repository}) : super(CreditsInitial()) {
    on<GetCreditsEvent>(_onGetCredits);
    on<AddCreditsEvent>(_onAddCredits);
  }

  FutureOr<void> _onGetCredits(GetCreditsEvent event, Emitter<CreditsState> emit) {
    emit(CurrentAmountCreditsState(credits: repository.credits));
  }

  FutureOr<void> _onAddCredits(AddCreditsEvent event, Emitter<CreditsState> emit) {
    if (event.amount < 0) {
      emit(ErrorCreditsState(message: "Cannot add negative credits"));
      return Future.value();
    }
    repository.addCredits(event.amount);
    emit(CurrentAmountCreditsState(credits: repository.credits));
  }
}