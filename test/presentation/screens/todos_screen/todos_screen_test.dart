import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';
import 'package:tasks_app/presentation/screens/create_todo_screen/create_todo_screen.dart';
import 'package:tasks_app/presentation/screens/todos_screen/todos_screen.dart';
import 'package:tasks_app/presentation/screens/todos_screen/widgets/todo_card.dart';
import 'package:tasks_app/presentation/screens/todos_screen/widgets/todos_list.dart';
import 'package:tasks_app/presentation/shared/main_app_bar.dart';

import '../../../helpers/test_helper.dart';
import '../../../mocks/navigator_observer.mocks.dart';

class MockTodosCubit extends Mock implements TodosCubit {}

class MockStorage extends Mock implements Storage {}

void main() async {
  group('Todos screen', () {
    late final MockNavigatorObserver mockObserver;

    setUpAll(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets(
      'Todos screen should have appBar with title: Home Screen and todosList and Floating action button',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TestsHelper.parentWidget(
            const TodosScreen(title: 'Todos'),
            // mockObserver,
          ),
        );

        final appBarFinder = find.byType(MainAppBar);

        final titleFinder = find.text('Todos');

        final todosListFinder = find.byType(ReordableList);

        final fabFinder = find.byType(FloatingActionButton);

        // Check if there is appBar
        expect(appBarFinder, findsOneWidget);
        // Check if there is title
        expect(titleFinder, findsOneWidget);
        // Check if there is List with Todos
        expect(todosListFinder, findsOneWidget);
        // Check if there is Floating Action Button
        expect(fabFinder, findsOneWidget);
      },
    );

    testWidgets(
      "When floating action button is pressed, CreateTodo screen should be pushed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          TestsHelper.parentWidget(
            const TodosScreen(title: 'Todos'),
            mockObserver,
          ),
        );

        final fabFinder = find.byType(FloatingActionButton);

        await tester.tap(fabFinder);
        await tester.pumpAndSettle();

        /// Verify that a push event happened
        verify(mockObserver.didPush(any, any));

        expect(find.byType(CreateTodoScreen), findsOneWidget);
      },
    );

    testWidgets(
      "Should be visible 6, maximum 7 todo cards at once"
      " on screen without AppBar and BottomNavigationBar",
      (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(320, 1500);

        await tester.pumpWidget(
          TestsHelper.parentWidget(
            const TodosScreen(title: 'Todos'),
          ),
        );

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsNothing);
        expect(find.byType(TodoCard), findsNWidgets(6));

        await tester.drag(find.byType(ReordableList), Offset(0, -50.h));
        await tester.pump();

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsNothing);
        expect(find.byType(TodoCard), findsNWidgets(6));

        await tester.drag(find.byType(ReordableList), Offset(0, -50.h));
        await tester.pump();

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsNothing);
        expect(find.byType(TodoCard), findsNWidgets(6));

        await tester.drag(find.byType(ReordableList), Offset(0, -50.h));
        await tester.pump();

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsNothing);

        await tester.drag(find.byType(ReordableList), Offset(0, -50.h));
        await tester.pump();

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsOneWidget);

        await tester.drag(find.byType(ReordableList), Offset(0, -50.h));
        await tester.pump();

        expect(find.text('test 8'), findsNothing);
        expect(find.text('test 7'), findsOneWidget);

        await tester.drag(find.byType(ReordableList), Offset(0, 250.h));
        await tester.pump();

        expect(find.text('test 1'), findsOneWidget);
        expect(find.text('test 7'), findsNothing);
        expect(find.text('test 8'), findsNothing);
      },
    );

    // TODO find out how to test emiting state with hydrated bloc package
    // testWidgets(
    //   "When press on TodoCard should be redirected to TodoScreen",
    //   (WidgetTester tester) async {
    //     final mockCubit = MockTodosCubit();
    //     MockStorage storage = MockStorage();

    //     HydratedBlocOverrides.runZoned(
    //       () {
    //         // when<dynamic>(() => storage.read('TodoCubit')).thenReturn({
    //         //   'runtimeType': 'AppAnalyticsLoaded',
    //         //   'openingCount': 100,
    //         // });
    //         // when<dynamic>(
    //         //   () => storage.write('TodoCubit', Map<String, dynamic>()),
    //         // ).thenAnswer((_) async {});
    //         // expect(
    //         //   AppBloc(
    //         //     localAnalyticsRepository: analyticsRepository,
    //         //   ).state,
    //         //   AppAnalyticsLoaded(100),
    //         // );

    //         // verify<dynamic>(() => storage.read('AppBloc')).called(1);
    //         // verify<dynamic>(
    //         //   () => storage.write('AppBloc', any<Map<String, dynamic>>()),
    //         // ).called(1);
    //       },
    //       storage: storage,
    //     );

    //     await tester.pumpWidget(
    //       TestsHelper.parentWidget(
    //         TodosScreen(title: 'Todos'),
    //       ),
    //     );

    //     // when(
    //     //   mockCubit.selectTodo(
    //     //     TodoModel(id: '1', title: 'test 1'),
    //     //   ),
    //     // ).thenReturn(print('sdfsdfs'));

    //     // when(
    //     //   mockCubit.toJson(
    //     //     TodosState(
    //     //       completeTodoList: [],
    //     //       todosList: [],
    //     //     ),
    //     //   ),
    //     // ).

    //     expect(find.byType(TodoCard).first, findsOneWidget);
    //     await tester.tap(find.byType(TodoCard).first);
    //     // await tester.pump();

    //     // expect(find.byType(TodoCard).first, findsOneWidget);
    //   },
    // );
  });
}
