import 'package:expoleap/models/event.dart';
import 'package:expoleap/models/session.dart';
import 'package:expoleap/models/timetable_events.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState<T> with _$SessionState<T> {
  const factory SessionState.idle() = Idle<T>;

  const factory SessionState.loading() = Loading<T>;

  const factory SessionState.error({@Default('') String error}) = Error<T>;

  const factory SessionState.data({@Default([]) List<TimetableEvent> data}) =
      Data<T>;
}
