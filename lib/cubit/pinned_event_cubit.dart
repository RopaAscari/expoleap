import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:expoleap/state/pinned_event/pinned_event_state.dart';
import 'package:expoleap/resources/repositories/event_repository.dart';
import 'package:expoleap/resources/repositories/device_repository.dart';

class PinnedEventCubit extends Cubit<PinnedEventState> {
  PinnedEventCubit() : super(Idle());

  final EventRepository eventRepository = new EventRepository();
  final DeviceRepository deviceRepository = new DeviceRepository();

  void pinEvent({required String eventId}) async {
    try {
      final eventIds = await eventRepository.pinEvent(eventId);

      emit(PinnedEventState.loading());
      // await deviceRepository.registerDeviceToEvent(eventId);

      final events = await eventRepository.getPinnedEvents(eventIds);

      emit(PinnedEventState.data(pinnedEvents: events));
    } catch (err) {
      await eventRepository.unPinEvent(eventId);
      emit(PinnedEventState.error(error: err.toString()));
    }
  }

  void unPinEvent({required String eventId}) async {
    try {
      final eventIds = await eventRepository.unPinEvent(eventId);

      emit(PinnedEventState.loading());
      await deviceRepository.unRegisterDeviceFromEvent(eventId);

      final events = await eventRepository.getPinnedEvents(eventIds);

      emit(PinnedEventState.data(pinnedEvents: events));
    } catch (err) {
      emit(PinnedEventState.error(error: err.toString()));
    }
  }

  void fetchPinnedEvents() async {
    try {
      emit(PinnedEventState.loading());

      final eventIds = await eventRepository.getPinnedEventIds();

      final events = await eventRepository.getPinnedEvents(eventIds);

      emit(PinnedEventState.data(pinnedEvents: events));
    } catch (err) {
      emit(PinnedEventState.error(error: err.toString()));
    }
  }
}
