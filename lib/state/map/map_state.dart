import 'package:flutter/material.dart';
import 'package:expoleap/models/map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_state.freezed.dart';

@freezed
class MapState<T> with _$MapState<T> {
  const factory MapState.idle() = Idle<T>;

  const factory MapState.loading() = Loading<T>;

  const factory MapState.error({@Default('') String error}) = Error<T>;

  const factory MapState.data({required MapResponse data}) = Data<T>;
}
