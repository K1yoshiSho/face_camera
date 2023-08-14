import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/features/home/bloc/home_bloc.dart';
import 'package:face_camera_example/src/features/home/models/user.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:face_camera_example/src/services/http.dart';
import 'package:face_camera_example/src/utils/utils.dart';

abstract class HomeRepository {
  Future<void> postImage(PostImage event, Emitter<HomeState> emit);
}

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<void> postImage(PostImage event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeLoading());
      dynamic data = await HttpQuery().post(
        url: 'predict/',
        data: event.formData,
        headerData: getDefaultHeaders(),
      );

      if (data is DioException) {
        DioException e = data;
        getIt<Talker>().handle(e, e.stackTrace);
        emit(HomeFailure(error: e.message ?? "", errorDio: e));
      } else {
        emit(HomeFetched(user: User.fromJson(json: data), file: event.file));
      }
    } on DioException catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(HomeFailure(error: e.message ?? "", errorDio: e));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(HomeFailure(error: e.toString()));
    }
  }
}
