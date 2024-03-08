import 'dart:convert';
import 'dart:math';

import 'package:daily_routine/models/routine.dart';
import 'package:daily_routine/repositories/routine_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InMemoryRoutineRepository implements RoutineRepository {
  final List<Routine> _routines;
  final String _routinesKey = 'routines';

  InMemoryRoutineRepository({List<Routine>? initialRoutines})
      : _routines = initialRoutines ?? [];

  Future<void> initialize() async {
    if (_routines.isNotEmpty) {
      return;
    }
    _routines.addAll(await loadRoutines());
  }

  @override
  Future<List<Routine>> getAllRoutines() async {
    return _routines;
  }

  @override
  Future<List<Routine>> addRoutine(Routine routine) async {
    final newId =
        (_routines.isEmpty) ? 1 : (_routines.map((e) => e.id).reduce(max) + 1);
    final newRoutine = routine.copyWith(id: newId);
    _routines.add(newRoutine);
    await saveRoutines(_routines);
    return _routines;
  }

  /// Updates a routine in the repository.
  /// Throws a [RoutineNotFoundException] if the routine is not found.
  @override
  Future<List<Routine>> updateRoutine(Routine routine) async {
    final index = _routines.indexWhere((element) => element.id == routine.id);
    if (index == -1) {
      throw RoutineNotFoundException('Routine with id ${routine.id} not found');
    }
    _routines[index] = routine;
    await saveRoutines(_routines);
    return _routines;
  }

  /// Deletes a routine from the repository.
  /// Throws a [RoutineNotFoundException] if the routine is not found.
  @override
  Future<List<Routine>> deleteRoutine(int id) async {
    final index = _routines.indexWhere((element) => element.id == id);
    if (index == -1) {
      throw RoutineNotFoundException('Routine with id $id not found');
    }
    _routines.removeAt(index);
    await saveRoutines(_routines);
    return _routines;
  }

  /// Resets all routines in the repository.
  @override
  Future<List<Routine>> resetAllRoutines() async {
    var now = DateTime.now();
    var newRoutines = _routines
        .map((routine) {
          var newDate = DateTime(now.year, now.month, now.day,
              routine.time.hour, routine.time.minute);
          return routine.copyWith(time: newDate, isCompleted: false);
        })
        .toList();
    _routines.clear();
    _routines.addAll(newRoutines);
    await saveRoutines(_routines);
    return _routines;
  }

  /// Saves the routines to shared preferences.
  Future<void> saveRoutines(List<Routine> routines) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String json =
        jsonEncode(routines.map((routine) => routine.toJson()).toList());
    await prefs.setString(_routinesKey, json);
  }

  /// Loads the routines from shared preferences.
  Future<List<Routine>> loadRoutines() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(_routinesKey);
    if (json == null) {
      return [];
    }
    List<dynamic> jsonList = jsonDecode(json);
    return jsonList.map((json) => Routine.fromJson(json)).toList();
  }

  @override
  Future<Routine?> markRoutineComplete(int id) async {
    final index = _routines.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    _routines[index] = _routines[index].copyWith(isCompleted: true);
    await saveRoutines(_routines);
    return _routines[index];
  }

  @override
  Future<Routine?> markRoutineIncomplete(int id) async {
    final index = _routines.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    _routines[index] = _routines[index].copyWith(isCompleted: false);
    await saveRoutines(_routines);
    return _routines[index];
  }
}
