import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/features/home/bloc/home_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:face_camera/face_camera.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
part '../components/message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc();
  String? lastSuccessImage;
  bool isScanWork = true;
  // File? _capturedImage;
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
            if (lastSuccessImage != null) {
              OpenFile.open(lastSuccessImage);
            } else {
              Fluttertoast.showToast(
                msg: "Нет изображений",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 14,
              );
            }
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
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is HomeLoading) {
            setState(() {
              isScanWork = false;
            });
          } else if (state is HomeFetched) {
            getIt<Talker>().info("User ID: ${state.user.userId}");

            Future.delayed(
              const Duration(seconds: 1),
              () {
                // state = const HomeInitial();
                setState(() {
                  isScanWork = true;
                  lastSuccessImage = state.file.path;
                });
                getIt<Talker>().info("Image: ${state.file.path}");
              },
            );
          } else if (state is HomeFailure) {
            setState(() {
              isScanWork = true;
            });
          }
        },
        builder: (context, state) {
          if (state is HomeFetched) {}
          return SmartFaceCamera(
            imageResolution: ImageResolution.high,
            controller: _controller,
            enableAudio: false,
            autoCapture: false,
            showFlashControl: false,
            showCameraLensControl: false,
            showCaptureControl: false,
            defaultCameraLens: CameraLens.front,
            onCapture: (File? image) async {
              if (image != null && isScanWork) {
                File? temp = await fixImage(image.path) ?? image;
                lastSuccessImage = temp.path;
                MultipartFile multipartFile = await MultipartFile.fromFile(temp.path, contentType: MediaType('image', 'jpg'));
                FormData formData = FormData.fromMap({
                  'image': multipartFile,
                });
                getIt<Talker>().warning(formData.toString());
                _bloc.add(PostImage(formData: formData, file: temp));
              }
            },
            onFaceDetected: (Face? face) {
              if (face == null) {
                getIt<Talker>().info("Face: null");
              } else if (isScanWork) {
                getIt<Talker>().info("Call: takePicture");
                _controller.takePicture();
                // getIt<Talker>().info("Face: ${face.toString()}");
                // Future.delayed(const Duration(milliseconds: 1000), () {
                //   // getIt<Talker>().info("Face: ${face.toString()}");
                //   _controller.takePicture();
                // });
              }
            },
            messageBuilder: (context, face) {
              if (state is HomeLoading) {
                return const _MessageComponent(msg: 'Подождите, идет сканирование');
              } else if (state is HomeFailure) {
                return const _MessageComponent(msg: "Ошибка, попробуйте еще раз");
              } else if (state is HomeFetched) {
                return _MessageComponent(msg: 'Успех, вы авторизованы. Ваш ID: ${state.user.userId}}');
              } else {
                if (face == null) {
                  return const _MessageComponent(msg: 'Расположите лицо в кадр');
                } else if (state is HomeFetched) {
                  return const _MessageComponent(msg: 'Подождите, идет сканирование');
                } else if (!face.wellPositioned) {
                  return const _MessageComponent(msg: 'Расположите лицо в квадрат');
                } else if (face.wellPositioned) {
                  return const _MessageComponent(msg: 'Не двигайтесь, идет сканирование');
                }
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

Future<File?> fixImage(String imagePath) async {
  final img.Image? capturedImage = img.decodeImage(await File(imagePath).readAsBytes());
  if (capturedImage != null) {
    final img.Image orientedImage = img.copyRotate(capturedImage, angle: 0);
    final img.Image fixedImage = img.flipHorizontal(orientedImage);
    return await File(imagePath).writeAsBytes(img.encodeJpg(fixedImage));
  }
  return null;
}

// Future<img.Image> rotateImage90Degrees(img.Image originalImage) async {
//   return img.copyRotate(originalImage, angle: 90);
// }

// Future<File> fixImageRotation(File file) async {
//   final originalImage = img.decodeImage(await file.readAsBytes());
//   img.Image fixedImage;
//   switch (originalImage?.exif.or) {
//     case 3:
//       fixedImage = img.copyRotate(originalImage, 180);
//       break;
//     case 6:
//       fixedImage = img.copyRotate(originalImage, 90);
//       break;
//     case 8:
//       fixedImage = img.copyRotate(originalImage, -90);
//       break;
//     default:
//       fixedImage = originalImage;
//   }
//   final fixedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(fixedImage));
//   return fixedFile;
// }
