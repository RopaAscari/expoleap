import 'package:expoleap/cubit/notification_cubit.dart';
import 'package:expoleap/cubit/pinned_event_cubit.dart';

class EventCubitBundle {
  final PinnedEventCubit pinnedEventCubit;
  final NotificationCubit notificationCubit;

  EventCubitBundle(
      {required this.notificationCubit, required this.pinnedEventCubit});
}
