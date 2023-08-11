import 'package:face_camera_example/src/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FaceApp extends StatefulWidget {
  const FaceApp({Key? key}) : super(key: key);

  @override
  State<FaceApp> createState() => _FaceAppState();
}

class _FaceAppState extends State<FaceApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workspace Face ID",
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => "Workspace Face ID",
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
