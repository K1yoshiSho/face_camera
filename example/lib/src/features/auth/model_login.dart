// ignore_for_file: unused_field, cancel_subscriptions

import 'package:face_camera_example/src/services/app_model.dart';
import 'package:flutter/material.dart';

/// [LoginScreenModel] - model for login screen, where init and dispose fields.
class LoginScreenModel extends AppModel {
  late TextEditingController serverController;
  late TextEditingController turntillController;
  bool isEntry = false;

  late final GlobalKey<ScaffoldState> scaffoldKey;
  late final GlobalKey<FormState> formKey;

  @override
  void initState(BuildContext context) {
    serverController = TextEditingController(text: "https://");
    turntillController = TextEditingController();

    scaffoldKey = GlobalKey<ScaffoldState>();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    serverController.dispose();
    turntillController.dispose();
  }
}
