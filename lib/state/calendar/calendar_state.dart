import 'package:expoleap/models/event.dart';
import 'package:expoleap/models/calendar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState<T> with _$CalendarState<T> {
  const factory CalendarState.idle() = Idle<T>;

  const factory CalendarState.loading() = Loading<T>;

  const factory CalendarState.error({@Default('') String error}) = Error<T>;

  const factory CalendarState.data(
      {required Map<DateTime, List<Calendar>> data}) = Data<T>;
}
