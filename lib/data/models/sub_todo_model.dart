import 'package:tasks_app/data/models/unique_entity.dart';

class SubTodoModel extends UniqueEntity {
  final String title;
  final bool isDone;

  SubTodoModel({
    required String id,
    required this.title,
    this.isDone = false,
  }) : super(id);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': super.id,
      'title': title,
      'isDone': isDone,
    };
  }

  factory SubTodoModel.fromMap(Map<String, dynamic> map) {
    return SubTodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      isDone: (map['isDone'] as bool?) ?? false,
    );
  }

  SubTodoModel copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return SubTodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  String toString() => 'SubTodoModel(id: $id, title: $title, isDone: $isDone)';
}
