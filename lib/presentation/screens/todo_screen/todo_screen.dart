import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/data/models/todo_model.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';
import 'package:tasks_app/presentation/router/app_router.dart';
import 'package:tasks_app/presentation/screens/create_todo_screen/create_todo_screen.dart';
import 'package:tasks_app/presentation/screens/todo_screen/widgets/checkbox_with_title.dart';
import 'package:tasks_app/presentation/shared/appbar_progress_indicator.dart';
import 'package:tasks_app/presentation/shared/main_app_bar.dart';
import 'package:tasks_app/presentation/shared/main_page_layout.dart';

class TodoArguments {
  final bool disableSubToDo;

  TodoArguments({this.disableSubToDo = false});
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  void toggleSubTodo(
    BuildContext context, {
    required TodoModel? selectedTodo,
    required List<TodoModel> todosList,
    required int index,
  }) {
    if (selectedTodo == null) return;

    final TodoModel updatedTodo = updateTodo(index: index, todo: selectedTodo);

    final List<TodoModel> updatedTodos = updateTodosList(
      todosList: todosList,
      updatedTodo: updatedTodo,
    );

    final TodosCubit cubit = BlocProvider.of<TodosCubit>(context);

    cubit.updateTodos(updatedTodos);
    cubit.selectTodo(updatedTodo);

    if (cubit.state.selectedTodo!.subTodos
            .where((element) => element.isDone)
            .length ==
        cubit.state.selectedTodo!.subTodos.length) {
      _showDialog(
        context: context,
        addToComplete: () {
          cubit.addCompleteTodo(updatedTodo);
        },
      );
    }
  }

  TodoModel updateTodo({
    required TodoModel todo,
    required int index,
  }) {
    final subTodos = [...todo.subTodos];
    final subTodo = subTodos[index];
    final isDone = subTodo.isDone;
    final updatedSubTodo = subTodo.copyWith(isDone: !isDone);
    final updatedSubTodos = subTodos
      ..removeAt(index)
      ..insert(index, updatedSubTodo);
    final TodoModel updatedTodo = todo.copyWith(subTodos: updatedSubTodos);

    return updatedTodo;
  }

  List<TodoModel> updateTodosList({
    required List<TodoModel> todosList,
    required TodoModel updatedTodo,
  }) {
    final todos = [...todosList];

    final indexOfTodo =
        todos.indexWhere((element) => element.id == updatedTodo.id);

    final updatedTodos = todos
      ..removeAt(indexOfTodo)
      ..insert(indexOfTodo, updatedTodo);

    return updatedTodos;
  }

  void _showDialog({
    required BuildContext context,
    required VoidCallback addToComplete,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todo is completed.'),
        content: const Text('Do you want to archive?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No')),
          TextButton(
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(AppRouter.mainTabScreen));
                addToComplete();
              },
              child: const Text('Yes')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as TodoArguments?;
    return BlocBuilder<TodosCubit, TodosState>(
      builder: (context, state) {
        return MainPageLayout(
          appBar: MainAppBar(
            title: state.selectedTodo?.title ?? 'NA',
            actions: [
              if (args == null)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.createTodo,
                        arguments: TodoScreenType.update);
                  },
                  icon: const Icon(Icons.edit),
                ),
            ],
            bottom: AppBarProgressIndicator(),
          ),
          body: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemBuilder: (context, index) => CheckboxWithTitle(
              title: state.selectedTodo?.subTodos[index].title ?? 'NA',
              value: state.selectedTodo?.subTodos[index].isDone ?? false,
              onTap: args != null && args.disableSubToDo
                  ? () {}
                  : () => toggleSubTodo(
                        context,
                        selectedTodo: state.selectedTodo,
                        todosList: state.todosList,
                        index: index,
                      ),
            ),
            itemCount: state.selectedTodo?.subTodos.length,
          ),
        );
      },
    );
  }
}
