import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({@Default([]) List<T> data}) = Success<T>;

  const factory ApiResult.failure(
          {@Default(NetworkExceptions.badRequest()) NetworkExceptions error}) =
      Failure<T>;
}
