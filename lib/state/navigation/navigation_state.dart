import 'package:flutter/material.dart';
import 'package:expoleap/models/notification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

part 'navigation_state.freezed.dart';

@freezed
class NavigationState<T> with _$NavigationState<T> {
  const factory NavigationState.idle() = Idle<T>;

  const factory NavigationState.error({@Default('') String error}) = Error<T>;
}
