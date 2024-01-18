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

  group('Credits Bloc add credits', () {
    blocTest<CreditsBloc, CreditsState>(
        'initialized with 5 credits, adds 5 credits when asked to add 5 credits',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(AddCreditsEvent(5)),
        expect: () => [CurrentAmountCreditsState(credits: 10)]
    );

    blocTest<CreditsBloc, CreditsState>(
      'initialized with 0 credits, adds 5 credits when asked to add 5 credits',
      build: () =>
          CreditsBloc(repository: InMemoryCreditsRepository(credits: 0)),
      act: (bloc) => bloc.add(AddCreditsEvent(5)),
      expect: () => [CurrentAmountCreditsState(credits: 5)]
    );

    blocTest<CreditsBloc, CreditsState>(
      'initialized with 5 credits, adds 0 credits when asked to add 0 credits',
      build: () =>
          CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
      act: (bloc) => bloc.add(AddCreditsEvent(0)),
      expect: () => [CurrentAmountCreditsState(credits: 5)]
    );

    blocTest<CreditsBloc, CreditsState>(
      'initialized with 5 credits, returns error state when asked to add negative credits',
      build: () =>
          CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
      act: (bloc) => bloc.add(AddCreditsEvent(-5)),
      expect: () => [ErrorCreditsState(message: "Cannot add negative credits")],
      verify: (bloc) => expect(bloc.repository.credits, 5)
    );
  });

  group('Credits Bloc withdraw credits', () {
    blocTest('initialized with 5 credits, withdraws 5 credits when asked to withdraw 5 credits',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(WithdrawCreditsEvent(5)),
        expect: () => [CurrentAmountCreditsState(credits: 0)]
    );

    blocTest('initialized with 5 credits, withdraws 0 credits when asked to withdraw 0 credits',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(WithdrawCreditsEvent(0)),
        expect: () => [CurrentAmountCreditsState(credits: 5)]
    );

    blocTest('initialized with 5 credits, returns error state when asked to withdraw negative credits',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(WithdrawCreditsEvent(-5)),
        expect: () => [ErrorCreditsState(message: "Cannot withdraw negative credits")],
        verify: (bloc) => expect(bloc.repository.credits, 5)
    );

    blocTest('initialized with 5 credits, returns error state when asked to withdraw more credits than available',
        build: () =>
            CreditsBloc(repository: InMemoryCreditsRepository(credits: 5)),
        act: (bloc) => bloc.add(WithdrawCreditsEvent(10)),
        expect: () => [ErrorCreditsState(message: "Cannot withdraw more credits than available")],
        verify: (bloc) => expect(bloc.repository.credits, 5)
    );
  });
}
