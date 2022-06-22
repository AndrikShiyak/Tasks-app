import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/presentation/shared/appbar_progress_indicator.dart';
import 'package:tasks_app/presentation/shared/main_app_bar.dart';

import '../../helpers/test_helper.dart';

void main() {
  testWidgets('Test Main Appbar', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestsHelper.parentWidget(
        Scaffold(
          appBar: MainAppBar(
            title: 'Test Title',
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );

    MainAppBar appBar = tester.firstWidget<MainAppBar>(find.byType(MainAppBar));
    final Size appBarSize = tester.getSize(find.byType(MainAppBar));

    final titleFinder = find.text('Test Title');
    final Text title = tester.firstWidget<Text>(titleFinder);
    final Size titleSize = tester.getSize(titleFinder);

    // Check appBar height
    expect(appBar.preferredSize.height, kToolbarHeight);
    // Check whether the indentation from the left to the title is equal to the indentation from the right
    expect(
        (appBarSize.width / 2 - titleSize.width / 2).floor(),
        (appBarSize.width - (appBarSize.width / 2 + titleSize.width / 2))
            .floor());
    // Check font size of the title
    expect(title.style?.fontSize, 22.sp);
    // Check font weight of the title
    expect(title.style?.fontWeight, FontWeight.w500);
    // Check color of the title
    expect(title.style?.color, Colors.white);
    // Check if there are actions
    expect(appBar.actions?.length, greaterThan(0));
    // Check background color of the appbar
    expect(appBar.backgroundColor, Colors.green);

    await tester.pumpWidget(
      TestsHelper.parentWidget(
        Scaffold(
          appBar: MainAppBar(
            title: 'Test Title',
            bottom: AppBarProgressIndicator(),
          ),
        ),
      ),
    );

    appBar = tester.firstWidget<MainAppBar>(find.byType(MainAppBar));

    final bottomFinder = find.byType(AppBarProgressIndicator);
    final AppBarProgressIndicator bottomWidget =
        tester.firstWidget(bottomFinder);

    final progressFinder = find.byType(AnimatedContainer);
    final AnimatedContainer progress = tester.firstWidget(progressFinder);

    final backgroundFinder =
        find.ancestor(of: progressFinder, matching: find.byType(Container));
    final Container background = tester.firstWidget(backgroundFinder);

    // Check if there is a bottom widget
    expect(bottomFinder, findsOneWidget);
    // Check height of the bottom widget
    expect(bottomWidget.height, 20.h);
    // Check color of the background
    expect(background.color, Colors.white);
    // Check color of the progress
    expect((progress.decoration as BoxDecoration).color,
        Colors.green.withOpacity(0.6));
    // Check width of the progress
    expect(tester.getSize(progressFinder).width, 800 / 2);
  });
}
