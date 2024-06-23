import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/splash_page.dart';
import 'package:fun_joke/business/user/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ProviderScope(child: MyApp()));
}

final _routes = {
  '/': (context) => const SplashPage(),
  '/login': (context) => const LoginPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              surface: Colors.white,
          ),
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        onGenerateRoute: (settings) {
          final route = _routes[settings.name];
          if (route == null) return null;
          return CupertinoPageRoute(
            builder: (context) {
              return route.call(context);
            },
          );
        },
        initialRoute: '/',
        routes: _routes,
        builder: FlutterSmartDialog.init(),
        navigatorObservers: [FlutterSmartDialog.observer],
      ),
    );
  }
}