import 'package:dio/dio.dart';
import 'package:offline_first/shared_preferences_service.dart';

enum DioMethod {
  get,
  post,
  delete,
  put,
  patch;

  const DioMethod();
}

class CustomInterceptor extends InterceptorsWrapper {
  final _prefs = SharedPreferencesService.instance;

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.requestOptions.method == DioMethod.get.name.toUpperCase()) {
      await _prefs.add(response.requestOptions.path, response.data);
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type
        case DioExceptionType.connectionTimeout ||
            DioExceptionType.unknown ||
            DioExceptionType.connectionError) {
      final data = _prefs.get(err.requestOptions.path);

      if (data != null && data != '') {
        handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: data,
          ),
        );
        return;
      }
    }

    super.onError(err, handler);
  }
}
