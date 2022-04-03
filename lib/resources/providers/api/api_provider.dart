import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class ApiProvider {
  late Dio _dio;

  ApiProvider() {
    initializeApi();
  }

  Dio get httpClient => _dio;

  void initializeApi() async {
    _dio = new Dio();

    final String token = dotenv.get('TOKEN');
    final String baseUrl = dotenv.get('BASE_URL');
    final int timeout = int.parse(dotenv.get('TIMEOUT'));

    _dio
      ..httpClientAdapter
      ..interceptors
          .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor)
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = timeout
      ..options.receiveTimeout = timeout
      ..interceptors.add(InterceptorsWrapper())
      ..options.headers.addAll({'CTOKEN': '$token'});

    if (kDebugMode) {
      /* _dio.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: true,
          requestBody: false));*/
    }
  }
}
