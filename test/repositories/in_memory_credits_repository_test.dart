import 'package:daily_routine/repositories/in_memory_credits_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Credits Repository Initialization Tests', () {
    test('Initializes with 0 credits', () {
      final repository = InMemoryCreditsRepository();
      expect(repository.credits, 0);
    });

    test('Initializes with 5 credits', () {
    });

    test('Throws exception if initialized with negative credits', () {
    });
  });

  group('Credits Repository Add Credits Tests', () {
    test('Adds 1 credit', () {
    });

    test('Adds 5 credits', () {
    });

    test('Throws exception if adding negative credits', () {
    });
  });

  group('Credits Repository Withdraws Credits Tests', () {
    test('Withdraws 1 credit', () {
    });

    test('Withdraws 5 credits', () {
    });

    test('Throws exception if withdrawing negative credits', () {
    });

    test('Throws exception if withdrawing more credits than available', () {
    });
  });
}