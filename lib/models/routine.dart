/// Model class for a routine
class Routine {
  final int id;
  final String name;
  final DateTime time;
  final bool isCompleted;

  Routine(
      {required this.id,
      required this.name,
      required this.time,
      this.isCompleted = false});
}
