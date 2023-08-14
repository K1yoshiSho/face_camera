import 'dart:async';
import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:face_camera_example/src/features/app/app.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/services/handling.dart';
import 'package:face_camera_example/src/services/local_storage/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  runZonedGuarded(() async {
    BindingBase.debugZoneErrorsAreFatal = true;
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // Preserves the native splash screen on the screen for some time and displays it until the Flutter app is fully loaded.
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    assert(widgetsBinding.debugCheckZone('startup'));
    sharedPreference.initSharedPreferences();

    await FaceCamera.initialize();
    final Talker talker = TalkerFlutter.init();
    talker.debug("📱 App Started");

    await initGetIt(talker: talker);
    await initHandling(talker: talker);
    runApp(DevicePreview(
      enabled: false,
      builder: (context) => const FaceApp(),
    ));
  }, (error, st) {
    getIt<Talker>().handle(error, st);
  });
}
