import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fun_joke/app_routes.dart';
import 'package:fun_joke/business/common/photo_preview/photo_preivew_page.dart';
import 'package:fun_joke/splash_page.dart';
import 'package:fun_joke/business/user/login/login_page.dart';
import 'package:fun_joke/utils/joke_log.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const ProviderScope(child: MyApp()));
}



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
        title: 'fun joke',
        theme: ThemeData(
          // 使用ListView 。滚动时 AppBar 改变颜色问题
          appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.0),
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
          final route = AppRoutes.routes[settings.name];
          if (route == null) return null;
          JokeLog.i('args: ${settings.arguments}');
          if (settings.name == AppRoutes.previewPage) {
            return PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) {
              return FadeTransition(opacity: animation, child: route.call(context, settings.arguments),);
            });
          }
          return CupertinoPageRoute(
            builder: (context) {
              return route.call(context, settings.arguments);
            },
          );
        },
        initialRoute: AppRoutes.indexPage,
        builder: FlutterSmartDialog.init(),
        navigatorObservers: [FlutterSmartDialog.observer],
      ),
    );
  }
}