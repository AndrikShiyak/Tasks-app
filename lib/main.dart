import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks_app/logic/cubit/todos_cubit.dart';

import 'core/constants/strings.dart';
import 'core/themes/app_theme.dart';
import 'logic/debug/app_bloc_observer.dart';
import 'presentation/router/app_router.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(
        as: #MockNavigatorObserver, returnNullOnMissingStub: true),
  ],
)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HydratedStorage storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  // storage.clear();
  // print('cleared');
  // return;

  // return;

  HydratedBlocOverrides.runZoned(
    () => runApp(
      const App(),
    ),
    storage: storage,
    blocObserver: AppBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      builder: (context, widget) => BlocProvider<TodosCubit>(
        create: (context) => TodosCubit(),
        child: MaterialApp(
          title: Strings.appTitle,
          // TODO change theme or colors in theme depending on current time?
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.mainTabScreen,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
