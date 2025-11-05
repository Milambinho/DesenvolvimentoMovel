class Task {
  int? id;
  String title;
  String description;
  String date;
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      isDone: map['isDone'] == 1,
    );
  }
}
