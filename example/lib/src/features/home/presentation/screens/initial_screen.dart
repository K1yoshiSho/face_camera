import 'package:face_camera_example/src/common/components/loader.dart';
import 'package:face_camera_example/src/features/auth/login_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/home_screen.dart';
import 'package:face_camera_example/src/router/navigation.dart';
import 'package:face_camera_example/src/services/local_storage/shared_preferences.dart';
import 'package:flutter/material.dart';

/// `InitialScreen` - initial screen for app

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});
  static const String name = "Initial";
  static const String routeName = "/initial";

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (sharedPreference.chosenServer.isNotEmpty) {
        context.goNamed(HomeScreen.name);
      } else {
        context.goNamed(LoginScreen.name);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Image.asset(
                "assets/icon/app_logo.png",
                height: 100,
                width: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * 0.35,
              ),
              child: const LoadingComponent(),
            )
          ],
        ),
      ),
    );
  }
}
