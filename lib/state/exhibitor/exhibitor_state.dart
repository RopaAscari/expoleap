import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expoleap/models/exhibitor.dart';

part 'exhibitor_state.freezed.dart';

@freezed
class ExhibitorState<T> with _$ExhibitorState<T> {
  const factory ExhibitorState.idle() = Idle<T>;

  const factory ExhibitorState.loading() = Loading<T>;

  const factory ExhibitorState.error({@Default('') String error}) = Error<T>;

  const factory ExhibitorState.data(
      {required Map<String, List<Exhibitor>> exhibitors}) = Data<T>;
}
