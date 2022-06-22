import 'package:flutter/material.dart';

class IconButtonW extends StatelessWidget {
  const IconButtonW({
    Key? key,
    required this.icon,
    this.onTap,
    this.color,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: color,
      ),
    );
  }
}
