import 'package:bloc/bloc.dart';
import 'package:expoleap/models/timetable_events.dart';
import 'package:expoleap/state/session/session_state.dart';
import 'package:expoleap/resources/repositories/session_repository.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(Idle());

  final SessionRepository sessionRepository = new SessionRepository();
  void fetchSessions({required String eventId}) async {
    try {
      emit(SessionState.loading());
      final List<TimetableEvent> sessions =
          await sessionRepository.fetchSessions(eventId);

      emit(SessionState.data(data: sessions));
    } catch (error) {
      emit(SessionState.error(error: error.toString()));
    }
  }
}
