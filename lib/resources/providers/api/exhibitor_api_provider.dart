import 'package:dio/dio.dart';
import 'package:expoleap/models/exhibitor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class ExhibitorApiProvider {
  final String _endpoint = '/v1/exhibitors/';
  final ApiProvider api = new ApiProvider();

  Future<ApiResult<Exhibitor>> getExhibitors() async {
    try {
      Response response = await api.httpClient.get(_endpoint,
          options: buildCacheOptions(Duration(days: 7), forceRefresh: true));
      try {
        return ApiResult.success(data: exhibitorsFromJson(response.data));
      } catch (e) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(e));
      }
    } on DioError catch (ex) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(ex));
    }
  }
}
