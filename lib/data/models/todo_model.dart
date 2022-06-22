import 'package:tasks_app/data/models/sub_todo_model.dart';
import 'package:tasks_app/data/models/unique_entity.dart';

class TodoModel extends UniqueEntity {
  final String _title;
  final List<SubTodoModel> _subTodos;

  TodoModel({
    required String id,
    required String title,
    List<SubTodoModel> subTodos = const [],
  })  : _title = title,
        _subTodos = subTodos,
        super(id);

  double get completePercentage {
    return _subTodos.isNotEmpty
        ? _subTodos.where((element) => element.isDone).length / _subTodos.length
        : 0;
  }

  String get title {
    return _title;
  }

  List<SubTodoModel> get subTodos {
    return [..._subTodos];
  }

  void addSubtodo(SubTodoModel subTodo, [int? index]) {
    if (index != null) {
      _subTodos.insert(index, subTodo);
    } else {
      _subTodos.add(subTodo);
    }
  }

  void removeSubtodo(int index) {
    _subTodos.removeAt(index);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': super.id,
      'title': _title,
      'subTodos': _subTodos.map((e) => e.toMap()).toList(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subTodos: (map['subTodos'] as List<dynamic>)
          .map((dynamic e) => SubTodoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'TodoModel(id: $id, title: $_title, subTodos: $_subTodos)';

  TodoModel copyWith({
    String? id,
    String? title,
    List<SubTodoModel>? subTodos,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? _title,
      subTodos: subTodos ?? _subTodos,
    );
  }
}
