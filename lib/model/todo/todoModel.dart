// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  int id;
  String title;
  String date_created;
  bool completed;
  String date_completed_by;
  String? completed_at;
  String description;
  TodoModel({
    required this.id,
    required this.title,
    required this.date_created,
    required this.completed,
    required this.date_completed_by,
    this.completed_at,
    required this.description,
  });

  TodoModel copyWith({
    int? id,
    String? title,
    String? date_created,
    bool? completed,
    String? date_completed_by,
    String? completed_at,
    String? description,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date_created: date_created ?? this.date_created,
      completed: completed ?? this.completed,
      date_completed_by: date_completed_by ?? this.date_completed_by,
      completed_at: completed_at ?? this.completed_at,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date_created': date_created,
      'completed': completed,
      'date_completed_by': date_completed_by,
      'completed_at': completed_at,
      'description': description,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      title: map['title'] as String,
      date_created: map['date_created'] as String,
      completed: map['completed'] as bool,
      date_completed_by: map['date_completed_by'] as String,
      completed_at:
          map['completed_at'] != null ? map['completed_at'] as String : null,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, date_created: $date_created, completed: $completed, date_completed_by: $date_completed_by, completed_at: $completed_at, description: $description)';
  }

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.date_created == date_created &&
        other.completed == completed &&
        other.date_completed_by == date_completed_by &&
        other.completed_at == completed_at &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        date_created.hashCode ^
        completed.hashCode ^
        date_completed_by.hashCode ^
        completed_at.hashCode ^
        description.hashCode;
  }
}
