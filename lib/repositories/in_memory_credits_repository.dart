import 'package:shared_preferences/shared_preferences.dart';

import 'credits_repository.dart';

class InMemoryCreditsRepository implements CreditsRepository {
  int _credits = 0;
  static const String _creditsKey = 'credits';

  static Future<InMemoryCreditsRepository> create({int? credits}) async {
    final loadedCredits = await _loadCredits(_creditsKey);
    return InMemoryCreditsRepository._internal(credits: credits ?? loadedCredits);
  }

  InMemoryCreditsRepository._internal({int? credits}) {
    assert(credits != null && credits >= 0);
    _credits = credits ?? 0;
  }

  @override
  void addCredits(int credits) async {
    assert(credits >= 0);
    _credits += credits;
    await _saveCredits();
  }

  @override
  int get credits => _credits;

  @override
  void withdrawCredits(int credits) async {
    assert(credits >= 0);
    assert(_credits >= credits);
    _credits -= credits;
    await _saveCredits();
  }

  static Future<int> _loadCredits(String creditsKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(creditsKey) ?? 0;
  }

  Future<void> _saveCredits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_creditsKey, _credits);
  }
}