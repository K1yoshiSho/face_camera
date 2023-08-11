import 'package:face_camera_example/src/constants/export.dart';
import 'package:face_camera_example/src/services/error_interceptor.dart';
import 'package:face_camera_example/src/services/get_it.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class HttpQuery {
  HttpQuery();

  ///* ---------------------------------- [HttpQuery] ---------------------------------- */
  /// This class contains custom methods for making http requests.

  /// [GET]
  Future<dynamic> get({required String url, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headerData}) async {
    try {
      Map<String, dynamic> header = {
        "Content-Type": "application/json",
      };

      Map<String, dynamic> tempQueryParameters = queryParameters ?? {};

      if (headerData != null) header.addAll(headerData);
      final Response result = await getDio().get(
        url,
        options: Options(
          sendTimeout: const Duration(milliseconds: 30000),
          receiveTimeout: const Duration(milliseconds: 60000),
          headers: header,
        ),
        queryParameters: tempQueryParameters,
      );
      return result.data;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {}
      if (error.type == DioExceptionType.receiveTimeout) {}
      return error;
    }
  }

  /// [POST]
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headerData,
  }) async {
    // Map<String, dynamic> header = {
    //   "Content-Type": "application/json",
    // };
    Map<String, dynamic> tempQueryParameters = queryParameters ?? {};
    // if (headerData != null) header.addAll(headerData);

    final Response result = await getDio().post(
      url,
      options: Options(
        method: 'POST',
        sendTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 120000),
        headers: headerData,
        contentType: Headers.formUrlEncodedContentType,
      ),
      queryParameters: tempQueryParameters,
      data: data,
    );
    return result.data;
  }

  /// [PATCH]
  Future<dynamic> patch({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headerData,
  }) async {
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> tempQueryParameters = queryParameters ?? {};

    if (headerData != null) header.addAll(headerData);

    final Response result = await getDio().patch(
      url,
      options: Options(
        method: 'PATCH',
        sendTimeout: const Duration(milliseconds: 120000),
        receiveTimeout: const Duration(milliseconds: 120000),
        headers: header,
      ),
      queryParameters: tempQueryParameters,
      data: data,
    );
    return result.data;
  }

  /// [PUT]
  Future<dynamic> put({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headerData,
  }) async {
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
    };

    if (headerData != null) header.addAll(headerData);
    Map<String, dynamic> tempQueryParameters = queryParameters ?? {};
    final Response result = await getDio().put(
      url,
      options: Options(
        sendTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 120000),
        headers: header,
      ),
      queryParameters: tempQueryParameters,
      data: data,
    );
    return result.data;
  }

  /// [DELETE]
  Future<dynamic> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headerData,
  }) async {
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> tempQueryParameters = queryParameters ?? {};

    if (headerData != null) header.addAll(headerData);
    final Response result = await getDio().delete(
      url,
      options: Options(
        headers: header,
      ),
      queryParameters: tempQueryParameters,
      data: data,
    );
    return result.data;
  }
}

Dio getDio() {
  Dio dio = Dio(BaseOptions(baseUrl: 'http://qt.workspace.kz:8100/'));

  /// Adds [ErrorInterceptor] to intercept and handle Dio errors across the app.
  dio.interceptors.add(ErrorInterceptor());

  /// Adds [TalkerDioLogger] to intercept Dio requests and responses and log them using Talker service.
  dio.interceptors.add(
    TalkerDioLogger(
      talker: getIt<Talker>(),
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printRequestData: true,
        printResponseData: true,
        printResponseHeaders: true,
        printResponseMessage: true,
        errorPen: AnsiPen()..red(bold: true),
      ),
    ),
  );
  return dio;
}

Dio getGeneralDio() {
  Dio dio = Dio();

  /// Adds [ErrorInterceptor] to intercept and handle Dio errors across the app.
  dio.interceptors.add(ErrorInterceptor());

  /// Adds [TalkerDioLogger] to intercept Dio requests and responses and log them using Talker service.
  dio.interceptors.add(
    TalkerDioLogger(
      talker: getIt<Talker>(),
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printRequestData: true,
        printResponseData: false,
        printResponseHeaders: true,
        printResponseMessage: true,
        errorPen: AnsiPen()..red(bold: true),
      ),
    ),
  );
  return dio;
}
