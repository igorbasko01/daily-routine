import 'credits_repository.dart';

class InMemoryCreditsRepository implements CreditsRepository {
  int _credits = 0;

  InMemoryCreditsRepository({int credits = 0}) {
    _credits = credits;
  }

  @override
  void addCredits(int credits) {
    // TODO: implement addCredits
  }

  @override
  int get credits => _credits;

  @override
  void withdrawCredits(int credits) {
    // TODO: implement withdrawCredits
  }
}