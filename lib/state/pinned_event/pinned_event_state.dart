import 'package:expoleap/models/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expoleap/models/pinned_event.dart';

part 'pinned_event_state.freezed.dart';

@freezed
class PinnedEventState<T> with _$PinnedEventState<T> {
  const factory PinnedEventState.idle() = Idle<T>;

  const factory PinnedEventState.loading() = Loading<T>;

  const factory PinnedEventState.error({@Default('') String error}) = Error<T>;

  const factory PinnedEventState.data(
      {required List<EventModel> pinnedEvents}) = Data<T>;
}
