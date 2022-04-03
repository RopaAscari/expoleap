import 'api_provider.dart';
import 'package:dio/dio.dart';
import 'package:expoleap/models/session.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class SessionApiProvider {
  final String _endpoint = 'v1/sessions/';
  final ApiProvider api = new ApiProvider();

  Future<ApiResult<Session>> getSessions() async {
    try {
      Response response = await api.httpClient.get(_endpoint,
          options: buildCacheOptions(Duration(days: 7), forceRefresh: true));
      return ApiResult.success(data: sessionsFromJson(response.data));
    } on DioError catch (ex) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(ex));
    }
  }
}
