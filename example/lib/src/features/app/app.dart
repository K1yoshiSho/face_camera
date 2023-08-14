import 'package:face_camera_example/src/router/navigation.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FaceApp extends StatefulWidget {
  const FaceApp({Key? key}) : super(key: key);

  @override
  State<FaceApp> createState() => _FaceAppState();
}

class _FaceAppState extends State<FaceApp> {
  late final GoRouter _router = createRouter();

  @override
  void initState() {
    _router.routerDelegate.addListener(() {
      getIt<Talker>().logTyped(
          TalkerLog(
            _router.routerDelegate.currentConfiguration.last.matchedLocation,
            title: WellKnownTitles.route.title,
            pen: AnsiPen()..rgb(r: 0.5, g: 0.5, b: 1.0),
            logLevel: LogLevel.info,
          ),
          logLevel: LogLevel.info);
    });
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Workspace Face ID",
      debugShowCheckedModeBanner: false,

      onGenerateTitle: (context) => "Workspace Face ID",
      theme: LightTheme,
      routerConfig: _router,
      // home: const HomeScreen(),
    );
  }
}
