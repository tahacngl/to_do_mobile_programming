
class Todo {
  int? id;
  late String userId;
  late String title;
  late String description;
  late String date;
  late String time;
  late int priority;
  late bool complete;

  Todo({
    this.id,
    required this.userId,
    required this.title,
    required this.priority,
    required this.date,
    required this.time,
    required this.description,
    this.complete = false,
  });

  Todo.withDate({
    required this.userId,
    required this.title,
    required String date,
    required String time,
    required this.priority,
    required this.description,
    this.complete = false,
  })  : this.date = date,
        this.time = time;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "title": title,
      "description": description,
      "priority": priority,
      "date": date,
      "time": time,
      "complete": complete ? 1 : 0,
    }..removeWhere((key, value) => value == null);
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      userId: map["user_id"],
      id: map["id"],
      title: map["title"],
      description: map["description"],
      date: map["date"],
      time: map["time"],
      priority: map["priority"],
      complete: map["complete"] == 1,
    );
  }

  bool isPast() {
    final now = DateTime.now();
    final taskDateTime = DateTime.parse('$date $time');
    return taskDateTime.isBefore(now);
  }

  Todo copyWith({
    int? id,
    String? userId,
    String? title,
    int? priority,
    String? date,
    String? time,
    String? description,
    bool? complete,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      complete: complete ?? this.complete,
    );
  }
}
