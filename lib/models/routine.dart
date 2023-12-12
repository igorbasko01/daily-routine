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

  Routine copyWith({int? id, String? name, DateTime? time, bool? isCompleted}) {
    return Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        time: time ?? this.time,
        isCompleted: isCompleted ?? this.isCompleted);
  }

  toggleCompleted() {
    return Routine(id: id, name: name, time: time, isCompleted: !isCompleted);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time.toIso8601String(),
      'isCompleted': isCompleted
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
        id: json['id'],
        name: json['name'],
        time: DateTime.parse(json['time']),
        isCompleted: json['isCompleted']);
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
    return id.hashCode ^ name.hashCode ^ time.hashCode ^ isCompleted.hashCode;
  }
}
