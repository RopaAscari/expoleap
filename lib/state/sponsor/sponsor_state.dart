import 'package:expoleap/models/sponsor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sponsor_state.freezed.dart';

@freezed
class SponsorState<T> with _$SponsorState<T> {
  const factory SponsorState.idle() = Idle<T>;

  const factory SponsorState.loading() = Loading<T>;

  const factory SponsorState.error({@Default('') String error}) = Error<T>;

  const factory SponsorState.data(
      {required Map<String, List<Sponsor>> sponsors}) = Data<T>;
}
