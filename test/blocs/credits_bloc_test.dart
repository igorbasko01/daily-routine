import 'package:bloc_test/bloc_test.dart';
import 'package:daily_routine/blocs/credits_bloc.dart';
import 'package:daily_routine/blocs/credits_event.dart';
import 'package:daily_routine/blocs/credits_state.dart';
import 'package:daily_routine/repositories/in_memory_credits_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Credits Bloc Initialization', () {
    blocTest<CreditsBloc, CreditsState>(
        'initialized with empty repository, returns zero credits when asked for credits',
        build: () => CreditsBloc(repository: InMemoryCreditsRepository()),
        act: (bloc) => bloc.add(GetCreditsEvent()),
        expect: () => [CurrentAmountCreditsState(credits: 0)]);

    blocTest<CreditsBloc, CreditsState>(
        'initialized with 5 credits, returns 5 credits when asked for credits',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(GetCreditsEvent()),
        expect: () => [CurrentAmountCreditsState(credits: 5)]);
  });
}
