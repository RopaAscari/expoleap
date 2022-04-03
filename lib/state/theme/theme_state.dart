import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class ThemeState<T> with _$ThemeState<T> {
  const factory ThemeState.idle() = Idle<T>;

  const factory ThemeState.loading() = Loading<T>;

  const factory ThemeState.error({@Default('') String error}) = Error<T>;

  const factory ThemeState.data({required String theme}) = Data<T>;
}
