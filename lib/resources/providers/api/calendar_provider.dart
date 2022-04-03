import 'dart:convert';
import 'api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expoleap/models/speaker.dart';
import 'package:expoleap/models/calendar.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class CalendarApiProvider {
  final String _endpoint = '/v1/calendar/';
  final ApiProvider api = new ApiProvider();

  Future<ApiResult<CalendarEvent>> getCalenderEvents() async {
    try {
      /* Response response = await api.httpClient.get(_endpoint,
          options: buildCacheOptions(Duration(days: 7), forceRefresh: true));*/

      List<dynamic> response = await rootBundle
          .loadString('./assets/calendar.json')
          .then((jsonStr) => jsonDecode(jsonStr));

      return ApiResult.success(data: calendarsFromJson(response));
    } on DioError catch (ex) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(ex));
    }
  }
}
