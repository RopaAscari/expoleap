import 'package:expoleap/models/session.dart';
import 'package:expoleap/models/timetable_events.dart';
import 'package:expoleap/resources/providers/api/session_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class SessionRepository {
  final SessionApiProvider _provider = new SessionApiProvider();
  Future<List<TimetableEvent>> fetchSessions(String eventId) async {
    final response = await _provider.getSessions();
    /* return [
      TimetableEvent(
        // session: session,
        eventName: "Test",
        to: DateTime.parse('2020-03-20T21:00:00Z'),
        from: DateTime.parse('2020-03-20T19:00:00Z'),
      ),
      TimetableEvent(
        // session: session,
        eventName: "Madness",
        to: DateTime.parse('2020-03-20T21:00:00Z'),
        from: DateTime.parse('2020-03-20T19:00:00Z'),
      )
    ];*/
    return response.when(
        success: (sessions) {
          return sessions
              .where((session) => session.event == eventId)
              .map((session) => TimetableEvent(
                    session: session,
                    eventName: session.title,
                    to: DateTime.parse('2020-03-21T20:00:00Z'),
                    from: DateTime.parse(session.start),
                  ))
              .toList();
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<Session> fetchSession(int sessionId) async {
    final response = await _provider.getSessions();

    return response.when(
        success: (sessions) {
          return sessions.firstWhere((session) => session.id == sessionId);
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }
}
