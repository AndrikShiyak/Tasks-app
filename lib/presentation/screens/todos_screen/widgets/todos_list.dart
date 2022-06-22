import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReordableList extends StatefulWidget {
  const ReordableList({
    Key? key,
    required this.children,
    required this.onReorder,
  }) : super(key: key);

  final List<Widget> children;
  final void Function(int, int) onReorder;

  @override
  State<ReordableList> createState() => _ReordableListState();
}

class _ReordableListState extends State<ReordableList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
      onReorder: widget.onReorder,
      children: widget.children,
    );

    // );
  }
}
