part of 'todos_cubit.dart';

class TodosState {
  TodosState({
    required List<TodoModel> todosList,
    required List<TodoModel> completeTodoList,
    TodoModel? selectedTodo,
  })  : _todosList = todosList,
        _selectedTodo = selectedTodo,
        _completeTodoList = completeTodoList;

  final List<TodoModel> _todosList;
  final TodoModel? _selectedTodo;
  final List<TodoModel> _completeTodoList;

  List<TodoModel> get todosList {
    return [..._todosList];
  }

  List<TodoModel> get completeTodoList {
    return [..._completeTodoList];
  }

  TodoModel? get selectedTodo {
    return _selectedTodo?.copyWith(
      subTodos: _selectedTodo?.subTodos,
    );
  }

  TodosState copyWith({
    List<TodoModel>? todosList,
    TodoModel? selectedTodo,
    List<TodoModel>? completeTodoList,
  }) {
    return TodosState(
      todosList: todosList ?? this.todosList,
      selectedTodo: selectedTodo ?? this.selectedTodo,
      completeTodoList: completeTodoList ?? this.completeTodoList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'todosList': _todosList.map((e) => e.toMap()).toList(),
      'completeTodoList': _completeTodoList.map((e) => e.toMap()).toList(),
      // 'selectedTodo': _selectedTodo?.toMap(),
    };
  }

  factory TodosState.fromMap(Map<String, dynamic> map) {
    return TodosState(
      todosList: (map['todosList'] as List<dynamic>)
          .map((e) => TodoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      completeTodoList: (map['completeTodoList'] as List<dynamic>)
          .map((e) => TodoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'TodosState todosList: $_todosList, selectedTodo: $_selectedTodo, completeTodoList: $_completeTodoList)';

  String toJson() => json.encode(toMap());

  factory TodosState.fromJson(String source) =>
      TodosState.fromMap(json.decode(source) as Map<String, dynamic>);
}
