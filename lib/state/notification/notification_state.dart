import 'package:expoleap/models/notification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState<T> with _$NotificationState<T> {
  const factory NotificationState.idle() = Idle<T>;

  const factory NotificationState.loading() = Loading<T>;

  const factory NotificationState.error({@Default('') String error}) = Error<T>;

  const factory NotificationState.data(
      {@Default([]) List<NotificationModel> data}) = Data<T>;
}
