import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/features/home/bloc/home_bloc.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/images_screen.dart';
import 'package:face_camera_example/src/features/home/presentation/screens/settings/settings_screen.dart';
import 'package:face_camera_example/src/router/navigation.dart';
import 'package:face_camera_example/src/services/local_storage/shared_preferences.dart';
import 'package:face_camera_example/src/theme/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:face_camera/face_camera.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/theme/app_colors.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
part '../components/message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = "Home";
  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc();
  // String? lastSuccessImage;

  List<File> images = [];
  bool isScanWork = true;
  final SmartFaceController _controller = SmartFaceController();

  @override
  void dispose() {
    _controller.stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            if (images.isNotEmpty) {
              _controller.stopCamera().then((value) {
                context.pushNamed(ImagesScreen.name, extra: {
                  ImagesScreen.paramImages: images,
                }).then((value) {
                  _controller.startCamera();
                });
              });
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
          icon: const Icon(
            Icons.format_list_bulleted_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _controller.stopCamera().then((value) {
                context.pushNamed(SettingsScreen.name).then((value) {
                  _controller.startCamera();
                });
              });
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _controller.stopCamera().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TalkerScreen(
                      talker: getIt<Talker>(),
                    ),
                  ),
                ).then(
                  (value) {
                    _controller.startCamera();
                  },
                );
              });
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'Workspace Face ID',
          style: AppTextStyle.bodyMedium500(context).copyWith(
            fontSize: 16,
            color: Colors.white,
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
              const Duration(milliseconds: 1500),
              () {
                setState(() {
                  isScanWork = true;
                  // images.add(state.file);
                });

                getIt<Talker>().info("Image: ${state.file.path}");
                _bloc.add(const ChangeState(state: HomeInitial()));
              },
            );
          } else if (state is HomeFailure) {
            Future.delayed(
              const Duration(milliseconds: 1500),
              () {
                setState(() {
                  isScanWork = true;
                });

                _bloc.add(const ChangeState(state: HomeInitial()));
              },
            );
          }
        },
        builder: (context, state) {
         
          return SmartFaceCamera(
            imageResolution: ImageResolution.high,
            controller: _controller,
            enableAudio: false,
            autoCapture: false,
            showFlashControl: false,
            showCameraLensControl: false,
            showCaptureControl: false,
            defaultCameraLens: CameraLens.front,
            isLoading: state is HomeLoading,
            isError: state is HomeFailure,
            isFetched: state is HomeFetched,
            onCapture: (File? image) async {
              if (image != null && isScanWork) {
                File? temp = await fixImage(image.path) ?? image;
                images.add(temp);
                MultipartFile multipartFile = await MultipartFile.fromFile(temp.path, contentType: MediaType('image', 'jpg'));
                FormData formData = FormData.fromMap({
                  'image': multipartFile,
                  'is_out': !sharedPreference.turntill.isEntry,
                  'entry_name': sharedPreference.turntill.name,
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
              }
            },
            messageBuilder: (context, face) {
              if (state is HomeLoading) {
                return const _MessageComponent(
                  title: 'Загрузка',
                  subTitle: 'Подождите, идет сканирование',
                  icon: Icon(
                    Icons.sync_rounded,
                    size: 24,
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (state is HomeFailure) {
                return const _MessageComponent(
                  title: 'Ошибка',
                  subTitle: 'Не удалось определить. Повторите попытку',
                  icon: Icon(
                    Icons.error_outline_rounded,
                    size: 24,
                    color: AppColors.dangerColor,
                  ),
                );
              } else if (state is HomeFetched) {
                return _MessageComponent(
                  title: "Успех",
                  subTitle: "Вы авторизованы. Ваш ID: ${state.user.userId}\n ФИО: ${state.user.name}",
                  icon: const Icon(
                    Icons.check_circle,
                    size: 24,
                    color: AppColors.successColor,
                  ),
                );
              } else {
                if (face == null) {
                  return _MessageComponent(
                    subTitle: 'Расположите лицо в кадр',
                    title: 'Внимание!',
                    icon: Icon(
                      Icons.warning_amber_rounded,
                      size: 24,
                      color: Colors.amber[800],
                    ),
                  );
                } else if (!face.wellPositioned) {
                  return _MessageComponent(
                      subTitle: 'Расположите лицо в квадрат',
                      title: 'Внимание!',
                      icon: Icon(
                        Icons.center_focus_weak_rounded,
                        size: 24,
                        color: Colors.amber[800],
                      ));
                } else if (face.wellPositioned) {
                  return _MessageComponent(
                    subTitle: 'Пожалуйста, не двигайтесь',
                    title: 'Внимание',
                    icon: Icon(
                      Icons.back_hand_rounded,
                      size: 24,
                      color: Colors.amber[800],
                    ),
                  );
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
