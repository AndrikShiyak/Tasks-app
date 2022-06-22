import 'package:flutter/material.dart';

class MainPageLayout extends StatelessWidget {
  const MainPageLayout({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.padding,
    this.appBar,
  }) : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;
  final EdgeInsets? padding;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
