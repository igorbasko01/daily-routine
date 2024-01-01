import 'package:daily_routine/repositories/in_memory_credits_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Credits Repository Initialization Tests', () {
    test('Initializes with 0 credits', () {
      final repository = InMemoryCreditsRepository();
      expect(repository.credits, 0);
    });

    test('Initializes with 5 credits', () {
      final repository = InMemoryCreditsRepository(credits: 5);
      expect(repository.credits, 5);
    });

    test('Throws exception if initialized with negative credits', () {
      expect(() => InMemoryCreditsRepository(credits: -1), throwsAssertionError);
    });
  });

  group('Credits Repository Add Credits Tests', () {
    test('Adds 1 credit', () {
      final repository = InMemoryCreditsRepository();
      repository.addCredits(1);
      expect(repository.credits, 1);
    });

    test('Adds 5 credits', () {
      final repository = InMemoryCreditsRepository();
      repository.addCredits(5);
      expect(repository.credits, 5);
    });

    test('Throws exception if adding negative credits', () {
      final repository = InMemoryCreditsRepository();
      expect(() => repository.addCredits(-1), throwsAssertionError);
    });
  });

  group('Credits Repository Withdraws Credits Tests', () {
    test('Withdraws 1 credit', () {
      final repository = InMemoryCreditsRepository(credits: 5);
      repository.withdrawCredits(1);
      expect(repository.credits, 4);
    });

    test('Withdraws 5 credits', () {
      final repository = InMemoryCreditsRepository(credits: 5);
      repository.withdrawCredits(5);
      expect(repository.credits, 0);
    });

    test('Throws exception if withdrawing negative credits', () {
      final repository = InMemoryCreditsRepository();
      expect(() => repository.withdrawCredits(-1), throwsAssertionError);
    });

    test('Throws exception if withdrawing more credits than available', () {
      final repository = InMemoryCreditsRepository();
      expect(() => repository.withdrawCredits(1), throwsAssertionError);
    });
  });
}