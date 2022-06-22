import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';

import '../../data/models/todo_model.dart';

class AppBarProgressIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  AppBarProgressIndicator({
    Key? key,
    double? height,
  }) : super(key: key) {
    this.height = height ?? 20.h;
  }

  late final double height;

  @override
  Widget build(BuildContext context) {
    final TodoModel todo =
        BlocProvider.of<TodosCubit>(context).state.selectedTodo!;

    final double greenContainerWidth =
        MediaQuery.of(context).size.width * todo.completePercentage;

    final double greenContainerColorOpacity =
        0.2 + 0.8 * todo.completePercentage;

    return Container(
      height: height,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: greenContainerWidth,
        color: Colors.green.withOpacity(greenContainerColorOpacity),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
