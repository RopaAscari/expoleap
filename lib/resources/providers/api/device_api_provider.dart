import 'api_provider.dart';
import 'package:dio/dio.dart';
import '../../../../models/device.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class DeviceApiProvider {
  final ApiProvider api = new ApiProvider();
  final String _endpoint = 'v1/fcm/devices/';

  // Register device
  Future<ApiResult<dynamic>> registerDevice(Device device) async {
    try {
      final Map<String, dynamic> device = new Device(
              registrationId: "54gdfgfrg6546456544gfh5tretgdfgrf",
              active: true,
              event: "969a6ca3-5982-4c99-b5d5-3a613219b3fc",
              type: "android")
          .toMap();
      Response response = await api.httpClient.post(_endpoint, data: device);

      if (response.statusCode != 200) {
        return ApiResult.failure(error: NetworkExceptions.badRequest());
      }

      return ApiResult.success(data: [true]);
    } on DioError catch (ex) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(ex));
    }
  }
}
