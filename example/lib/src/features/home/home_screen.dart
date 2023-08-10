import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:face_camera/face_camera.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _capturedImage;
  final SmartFaceController _controller = SmartFaceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            final tempDir = await getExternalStorageDirectory();
            OpenFile.open(tempDir?.path);
          },
          icon: const Icon(Icons.switch_camera),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(
                    talker: getIt<Talker>(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
        title: Text(
          'Workspace Face ID',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Inter",
              ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return SmartFaceCamera(
            imageResolution: ImageResolution.veryHigh,
            controller: _controller,
            enableAudio: false,
            autoCapture: false,
            showFlashControl: false,
            showCameraLensControl: false,
            showCaptureControl: false,
            defaultCameraLens: CameraLens.front,
            onCapture: (File? image) {
              // setState(() => _capturedImage = image);
              getIt<Talker>().info("Image: ${image?.path}");
            },
            onFaceDetected: (Face? face) {
              if (face == null) {
                getIt<Talker>().info("Face: null");
              } else {
                _controller.takePicture();
                // getIt<Talker>().info("Face: ${face.toString()}");
                // Future.delayed(const Duration(milliseconds: 1000), () {
                //   // getIt<Talker>().info("Face: ${face.toString()}");
                //   _controller.takePicture();
                // });
              }
            },
            messageBuilder: (context, face) {
              if (face == null) {
                return _message(msg: 'Расположите лицо в кадр');
              }

              if (!face.wellPositioned) {
                return _message(msg: 'Расположите лицо в квадрат');
              }
              if (face.wellPositioned) {
                return _message(msg: 'Не двигайтесь, идет сканирование');
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _message({required String msg}) => Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.65,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
