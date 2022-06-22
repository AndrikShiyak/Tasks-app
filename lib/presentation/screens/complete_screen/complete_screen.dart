import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';
import 'package:tasks_app/presentation/router/app_router.dart';
import 'package:tasks_app/presentation/screens/todo_screen/todo_screen.dart';
import 'package:tasks_app/presentation/screens/todos_screen/widgets/todo_card.dart';
import 'package:tasks_app/presentation/shared/main_app_bar.dart';
import 'package:tasks_app/presentation/shared/main_page_layout.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainPageLayout(
      appBar: MainAppBar(title: 'Completed'),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            itemBuilder: (context, index) => TodoCard(
              todo: state.completeTodoList[index],
              onTap: () {
                context
                    .read<TodosCubit>()
                    .selectTodo(state.completeTodoList[index]);
                Navigator.of(context).pushNamed(AppRouter.todo,
                    arguments: TodoArguments(disableSubToDo: true));
              },
              onDismissed: () => context
                  .read<TodosCubit>()
                  .deleteTodo(state.completeTodoList[index].id),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 20.h),
            itemCount: state.completeTodoList.length,
          );
        },
      ),
    );
  }
}
