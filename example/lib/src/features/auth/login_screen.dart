// ignore_for_file: use_build_context_synchronously

import 'package:face_camera_example/src/common/components/app_button.dart';
import 'package:face_camera_example/src/common/components/textfeld.dart';
import 'package:face_camera_example/src/common/models/turntill.dart';
import 'package:face_camera_example/src/features/auth/model_login.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/home_screen.dart';
import 'package:face_camera_example/src/router/navigation.dart';
import 'package:face_camera_example/src/services/app_model.dart';
import 'package:face_camera_example/src/services/local_storage/shared_preferences.dart';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:face_camera_example/src/theme/app_style.dart';
import 'package:flutter/material.dart';

/// [LoginScreen] - This screen is responsible for user login.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.isInitial = true}) : super(key: key);
  static const String name = "Login";
  static const String routeName = "/auth/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  final bool isInitial;
  static const String paramIsInitial = "paramIsInitial";
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginScreenModel _loginScreenModel;

  @override
  void initState() {
    _loginScreenModel = createModel(context, () => LoginScreenModel());

    super.initState();
  }

  @override
  void dispose() {
    _loginScreenModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginScreenModel.scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _loginScreenModel.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 35),
                          _buildLogo(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                            child: OutlinedTextfield(
                              textController: _loginScreenModel.serverController,
                              hintText: "Введите сервер",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: OutlinedTextfield(
                              textController: _loginScreenModel.turntillController,
                              hintText: "Введите наименование турникета",
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: CheckboxListTile(
                                dense: true,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: AppColors.gray300,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                tristate: true,
                                title: Text(
                                  "Вход",
                                  style: AppTextStyle.bodyMedium400(context).copyWith(fontSize: 12),
                                ),
                                value: _loginScreenModel.isEntry,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _loginScreenModel.isEntry = !_loginScreenModel.isEntry;
                                  });
                                },
                              )),
                          const SizedBox(height: 30),
                          AppButton(
                            text: "Сохранить",
                            onPressed: () async {
                              sharedPreference.setChosenServer(_loginScreenModel.serverController.text);
                              sharedPreference.setTurntill(
                                Turntill(id: 1, name: _loginScreenModel.turntillController.text, isEntry: _loginScreenModel.isEntry),
                              );
                              context.goNamed(HomeScreen.name);
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// `Widgets`

  SizedBox _buildLogo() {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          "assets/images/logo.webp",
        ),
      ),
    );
  }

  /// `Functions`
}
