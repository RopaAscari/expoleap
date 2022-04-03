import 'package:dio/dio.dart';
import 'package:expoleap/models/sponsor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class SponsorApiProvider {
  final String _endpoint = '/v1/sponsors/';
  final ApiProvider api = new ApiProvider();

  Future<ApiResult<Sponsor>> getSponsors() async {
    try {
      Response response = await api.httpClient.get(_endpoint,
          options: buildCacheOptions(Duration(days: 7), forceRefresh: true));
      return ApiResult.success(data: sponsorsFromJson(response.data));
    } on DioError catch (ex) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(ex));
    }
  }
}
