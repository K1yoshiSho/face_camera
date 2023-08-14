// ignore_for_file: unused_field, cancel_subscriptions

import 'package:face_camera_example/src/services/app_model.dart';
import 'package:face_camera_example/src/services/local_storage/shared_preferences.dart';
import 'package:flutter/material.dart';

/// [SettingsScreenModel] - model for login screen, where init and dispose fields.
class SettingsScreenModel extends AppModel {
  late TextEditingController serverController;
  late TextEditingController turntillController;
  bool isEntry = false;

  late final GlobalKey<ScaffoldState> scaffoldKey;
  late final GlobalKey<FormState> formKey;

  @override
  void initState(BuildContext context) {
    serverController = TextEditingController(text: sharedPreference.chosenServer);
    turntillController = TextEditingController(text: sharedPreference.turntill.name);
    isEntry = sharedPreference.turntill.isEntry;
    scaffoldKey = GlobalKey<ScaffoldState>();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    serverController.dispose();
    turntillController.dispose();
  }
}
