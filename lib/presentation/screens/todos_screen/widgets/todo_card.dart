import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/data/models/todo_model.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.onTap,
    required this.onDismissed,
    required this.todo,
    this.padding,
  }) : super(key: key);

  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final TodoModel todo;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final double greenContainerWidth =
        (MediaQuery.of(context).size.width - 40.w) * todo.completePercentage;

    final double greenContainerColorOpacity =
        0.2 + 0.8 * todo.completePercentage;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5.w),
            ),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            if (direction.name == 'endToStart') {
              onDismissed();
            }
          },
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Do you really want to delete?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes')),
                ],
              ),
            );
          },
          key: UniqueKey(),
          child: Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.r),
              boxShadow: [
                BoxShadow(
                  offset: Offset(1.r, 1.r),
                  color: Colors.green.shade100,
                  blurRadius: 4.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      key: const Key('greenContainer'),
                      width: greenContainerWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.green
                            .withOpacity(greenContainerColorOpacity),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Text(
                  todo.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(offset: Offset(1.5.w, 1.5.w))],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
