import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/data/models/sub_todo_model.dart';
import 'package:tasks_app/data/models/todo_model.dart';
import 'package:tasks_app/presentation/screens/todos_screen/widgets/todo_card.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  group(
    'Todo Card',
    () {
      testWidgets(
          'Todo Card must have title, rounded borders, color white and shadows',
          (WidgetTester tester) async {
        final TodoModel testTodo = TodoModel(
          id: '123',
          title: 'Test Title',
          subTodos: [],
        );
        await tester.pumpWidget(
          TestsHelper.parentWidget(
            TodoCard(
              todo: testTodo,
              onTap: () {},
              onDismissed: () {},
            ),
          ),
        );

        final title = find.text(testTodo.title);

        final boxDecoration = (tester
            .firstWidget<Container>(find.byType(Container))
            .decoration as BoxDecoration);
        final color = boxDecoration.color;
        final borderRadius = boxDecoration.borderRadius;
        final boxShadow = boxDecoration.boxShadow;

        // Check if there is a title
        expect(title, findsOneWidget);
        // Check background color of the card
        expect(color, Colors.white);
        // Check border radius of the card
        expect(borderRadius, BorderRadius.circular(5.r));
        // Check shadows count of the card
        expect(boxShadow?.length, 1);
        // Check shadow offset
        expect(boxShadow?[0].offset, Offset(1.r, 1.r));
        // Check shadow color
        expect(boxShadow?[0].color, Colors.green.shade100);
        // Check shadow blurRadius
        expect(boxShadow?[0].blurRadius, 4.r);
        // Check shadow spreadRadius
        expect(boxShadow?[0].spreadRadius, 2.r);
      });

      testWidgets(
        'Title must have fontSize 20.sp, fontweight medium, and shadow',
        (WidgetTester tester) async {
          final TodoModel testTodo = TodoModel(
            id: '123',
            title: 'Test Title',
            subTodos: [
              SubTodoModel(id: '111', title: 'test subtodo', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: false),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: false),
            ],
          );
          await tester.pumpWidget(
            TestsHelper.parentWidget(
              TodoCard(
                todo: testTodo,
                onTap: () {},
                onDismissed: () {},
              ),
            ),
          );

          final text = find.byType(Text);

          final shadows = tester.firstWidget<Text>(text).style?.shadows;

          // Check fontSize of the title
          expect(tester.firstWidget<Text>(text).style?.fontSize, 20.sp);
          // Check fontWeight of the title
          expect(tester.firstWidget<Text>(text).style?.fontWeight,
              FontWeight.w500);
          // Check shadows count
          expect(shadows?.length, 1);
          // Check shadow color
          expect(shadows?[0].color, Colors.black);
          // Check shadow blurRadius
          expect(shadows?[0].blurRadius, 0.0);
          // Check shadow offset
          expect(shadows?[0].offset, Offset(1.5.w, 1.5.w));
        },
      );

      group('Test width and color of green progress container', () {
        testWidgets(
            'Width should be 1/3 of TodoCard width and color = Colors.green with (0.2 + 0.8/3) opacity',
            (WidgetTester tester) async {
          final TodoModel testTodo = TodoModel(
            id: '123',
            title: 'Test Title',
            subTodos: [
              SubTodoModel(id: '111', title: 'test subtodo', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: false),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: false),
            ],
          );
          await tester.pumpWidget(
            TestsHelper.parentWidget(
              TodoCard(
                todo: testTodo,
                onTap: () {},
                onDismissed: () {},
              ),
            ),
          );

          final cardSize = tester.getSize(find.byType(TodoCard));

          final greenContainer = find.byKey(const Key('greenContainer'));
          final progressContainerSize = tester.getSize(greenContainer);
          final borderRadius = (tester
                  .firstWidget<Container>(greenContainer)
                  .decoration as BoxDecoration)
              .borderRadius;

          // Check progress container width
          expect(progressContainerSize.width, cardSize.width / 3);
          // Check progress container color
          expect(
              (tester.firstWidget<Container>(greenContainer).decoration
                      as BoxDecoration)
                  .color,
              Colors.green.withOpacity(0.2 + 0.8 / 3));
          // Check progress container border radius
          expect(borderRadius, BorderRadius.circular(5.r));
        });

        testWidgets(
            'Width should be 2/3 of TodoCard width and color = Colors.green with (0.2 + 0.8/3 * 2) opacity',
            (WidgetTester tester) async {
          final TodoModel testTodo = TodoModel(
            id: '123',
            title: 'Test Title',
            subTodos: [
              SubTodoModel(id: '111', title: 'test subtodo', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: false),
            ],
          );
          await tester.pumpWidget(
            TestsHelper.parentWidget(
              TodoCard(
                todo: testTodo,
                onTap: () {},
                onDismissed: () {},
              ),
            ),
          );

          final cardSize = tester.getSize(find.byType(TodoCard));

          final greenContainer = find.byKey(const Key('greenContainer'));
          final progressContainerSize = tester.getSize(greenContainer);

          // Check progress container width
          expect(progressContainerSize.width, (cardSize.width / 3) * 2);
          // Check progress container color
          expect(
              (tester.firstWidget<Container>(greenContainer).decoration
                      as BoxDecoration)
                  .color,
              Colors.green.withOpacity(0.2 + 0.8 / 3 * 2));
        });

        testWidgets(
            'Width should be same as TodoCard width and color = Colors.green with 1.0 opacity',
            (WidgetTester tester) async {
          final TodoModel testTodo = TodoModel(
            id: '123',
            title: 'Test Title',
            subTodos: [
              SubTodoModel(id: '111', title: 'test subtodo', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: true),
              SubTodoModel(id: '222', title: 'test subtodo2', isDone: true),
            ],
          );
          await tester.pumpWidget(
            TestsHelper.parentWidget(
              TodoCard(
                todo: testTodo,
                onTap: () {},
                onDismissed: () {},
              ),
            ),
          );

          final cardSize = tester.getSize(find.byType(TodoCard));

          final greenContainer = find.byKey(const Key('greenContainer'));
          final progressContainerSize = tester.getSize(greenContainer);

          // Check progress container width
          expect(progressContainerSize.width, cardSize.width);
          // Check progress container color
          expect(
              (tester.firstWidget<Container>(greenContainer).decoration
                      as BoxDecoration)
                  .color,
              Colors.green.withOpacity(1));
        });
      });
    },
  );
}
