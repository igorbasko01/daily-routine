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

  copyWith({required int id}) {
    return Routine(
        id: id, name: name, time: time, isCompleted: isCompleted);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Routine &&
        other.id == id &&
        other.name == name &&
        other.time == time &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        time.hashCode ^
        isCompleted.hashCode;
  }
}
