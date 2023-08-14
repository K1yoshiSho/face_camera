import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/services/get_it.dart';

import 'package:talker_bloc_logger/talker_bloc_logger.dart';

/// [Talker] - This class contains methods for handling errors and logging.

/// `initHandling` - This function initializes handling of the app.

Future<void> initHandling({required Talker talker}) async {
  FlutterError.presentError = (details) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      talker.handle(details.exception, details.stack);
    });
  };

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: true,
      printChanges: false,
      printStateFullData: true,
    ),
  );

  PlatformDispatcher.instance.onError = (error, stack) {
    getIt<Talker>().handle(error, stack);
    return true;
  };

  FlutterError.onError = (details) => getIt<Talker>().handle(details.exception, details.stack);
}
