import 'package:expoleap/models/speaker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker_state.freezed.dart';

@freezed
class SpeakerState<T> with _$SpeakerState<T> {
  const factory SpeakerState.idle() = Idle<T>;

  const factory SpeakerState.loading() = Loading<T>;

  const factory SpeakerState.error({@Default('') String error}) = Error<T>;

  const factory SpeakerState.data({required List<Speaker> speakers}) = Data<T>;
}
