import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/data/models/sub_todo_model.dart';
import 'package:tasks_app/data/models/todo_model.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';
import 'package:tasks_app/presentation/screens/create_todo_screen/widgets/icon_button_w.dart';
import 'package:tasks_app/presentation/screens/create_todo_screen/widgets/textfield_with_buttons.dart';
import 'package:tasks_app/presentation/shared/main_app_bar.dart';
import 'package:tasks_app/presentation/shared/main_page_layout.dart';

// TODO try to move fucntions into mixin, maybe this file become cleaner and more readable?

enum TodoScreenType {
  create,
  update,
}

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({
    Key? key,
    required this.title,
    required this.screenType,
  }) : super(key: key);

  final String title;
  final TodoScreenType screenType;

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  TodoModel _newTodo = TodoModel(id: '', title: '', subTodos: []);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.screenType == TodoScreenType.update) {
        _newTodo = TodoModel(
          id: context.read<TodosCubit>().state.selectedTodo!.id,
          title: context.read<TodosCubit>().state.selectedTodo!.title,
          subTodos: context.read<TodosCubit>().state.selectedTodo!.subTodos,
        );

        setState(() {});
      }
    });
    super.initState();
  }

  void _addSubTodoField() {
    setState(() {
      _newTodo.addSubtodo(SubTodoModel(id: _createUniqueKey(), title: ''));
    });
  }

  void _delete(String id) {
    setState(() {
      int index = _newTodo.subTodos.indexWhere((element) => element.id == id);
      if (index < 0) return;

      _newTodo.removeSubtodo(index);
    });
  }

  String _createUniqueKey() {
    final rng = math.Random();
    final int randomNumber = rng.nextInt(1000000);

    return '${math.pow(randomNumber, 3)}';
  }

  void _updateSubTodos({required String id, required String value}) {
    final index = _newTodo.subTodos.indexWhere((element) => element.id == id);

    if (index < 0) return;

    final SubTodoModel newSubTodo =
        _newTodo.subTodos[index].copyWith(title: value);

    _newTodo.removeSubtodo(index);

    _newTodo.addSubtodo(newSubTodo, index);
  }

  void _saveTodo() {
    if (_newTodo.title.isEmpty) return;

    for (var i = 0; i < _newTodo.subTodos.length; i++) {
      if (_newTodo.subTodos[i].title.isNotEmpty) continue;

      _newTodo.removeSubtodo(i);
    }

    if (_newTodo.id.isNotEmpty) {
      final List<TodoModel> todos = context.read<TodosCubit>().state.todosList;

      final int index =
          todos.indexWhere((element) => element.id == _newTodo.id);

      if (index >= 0) {
        todos.removeAt(index);
        todos.insert(index, _newTodo);
      }

      context.read<TodosCubit>().updateTodos(todos);
      context.read<TodosCubit>().selectTodo(_newTodo);
    } else {
      _newTodo = _newTodo.copyWith(id: _createUniqueKey());
      context.read<TodosCubit>().saveTodo(_newTodo);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      appBar: MainAppBar(
        title: widget.title,
        actions: [
          IconButtonW(
            icon: Icons.check,
            color: Colors.white,
            onTap: () => _saveTodo(),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Todo',
              style: Theme.of(context).textTheme.headline5,
            ),
            TextFieldWithButtons(
              key: Key(_newTodo.id),
              value: widget.screenType == TodoScreenType.update
                  ? _newTodo.title
                  : null,
              onChange: (value) => _newTodo = _newTodo.copyWith(title: value),
            ),
            SizedBox(height: 50.h),
            Text(
              'Sub Todo\'s',
              style: Theme.of(context).textTheme.headline5,
            ),
            if (widget.screenType == TodoScreenType.update)
              for (var subTodo in _newTodo.subTodos.asMap().entries)
                TextFieldWithButtons(
                  key: Key(subTodo.value.id),
                  value: subTodo.value.title,
                  onChange: (value) {
                    _updateSubTodos(id: subTodo.value.id, value: value);
                  },
                  delete: () => _delete(subTodo.value.id),
                )
            else
              for (var subTodo in _newTodo.subTodos.asMap().entries)
                TextFieldWithButtons(
                  key: Key(subTodo.value.id),
                  onChange: (value) {
                    _updateSubTodos(id: subTodo.value.id, value: value);
                  },
                  delete: () => _delete(subTodo.value.id),
                ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSubTodoField(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
