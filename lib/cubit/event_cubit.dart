import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:expoleap/state/event/event_state.dart';
import 'package:expoleap/resources/repositories/event_repository.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(Idle());

  final EventRepository eventRepository = new EventRepository();

  void searchEvents({required String term}) async {
    try {
      emit(EventState.loading());
      final searchedEvents = await eventRepository.searchEvents(term);
      emit(EventState.data(data: searchedEvents));
    } catch (err) {
      emit(EventState.error(error: err.toString()));
    }
  }
}
