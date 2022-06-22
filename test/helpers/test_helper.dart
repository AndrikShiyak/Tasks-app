import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasks_app/core/themes/app_theme.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';
import 'package:tasks_app/presentation/router/app_router.dart';

class TestsHelper {
  TestsHelper._();

  static Widget parentWidget(Widget child,
      [NavigatorObserver? navigatorObserver]) {
    return BlocProvider<TodosCubit>(
      create: (context) => TodosCubit.test(),
      child: ScreenUtilInit(
        designSize: const Size(375, 667),
        builder: (context, widget) => MaterialApp(
          navigatorObservers:
              navigatorObserver != null ? [navigatorObserver] : [],
          onGenerateRoute: AppRouter.onGenerateRoute,
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Builder(builder: (context) {
                return child;
              }),
            ),
          ),
        ),
      ),
    );
  }
}
