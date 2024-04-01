import 'package:dio/dio.dart';
import 'package:offline_first/custom_interceptor.dart';

class DioService {
  Dio call() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2/',
      ),
    );

    dio.interceptors.addAll([
      CustomInterceptor(),
    ]);

    return dio;
  }
}
