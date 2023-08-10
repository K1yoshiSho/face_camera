import 'dart:async';
import 'dart:ui';

import 'package:face_camera_example/src/features/app/app.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  runZonedGuarded(() async {
    BindingBase.debugZoneErrorsAreFatal = true;
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    assert(widgetsBinding.debugCheckZone('startup'));

    await FaceCamera.initialize();
    final Talker talker = TalkerFlutter.init();
    talker.debug("📱 App Started");

    await initGetIt(talker: talker);
    runApp(const FaceApp());
  }, (error, st) {
    getIt<Talker>().handle(error, st);
  });
}
