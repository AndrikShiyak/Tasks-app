import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  late final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );

    backgroundColor = appBar.backgroundColor ?? Theme.of(context).primaryColor;

    return appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom != null ? bottom!.preferredSize.height : 0));
}
