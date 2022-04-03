import 'package:expoleap/models/event.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/event_api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';
import 'package:expoleap/resources/providers/db/pinned_event_sql_provider.dart';

class EventRepository {
  final EventApiProvider _provider = new EventApiProvider();

  Future<List<Map<String, Object?>>> pinEvent(String eventId) async {
    return await updatePinnedEvents(eventId);
  }

  Future<List<Map<String, Object?>>> unPinEvent(String eventId) async {
    return await removePinnedEvents(eventId);
  }

  Future<List<Map<String, Object?>>> updatePinnedEvents(String id) async {
    return await PinnedEventSQLProvider.instance.updatePinnedEvents(id);
  }

  Future<List<Map<String, Object?>>> removePinnedEvents(String id) async {
    return await PinnedEventSQLProvider.instance.deletePinnedEvent(id);
  }

  Future<List<Map<String, Object?>>> getPinnedEventIds() async {
    return await PinnedEventSQLProvider.instance.retrievePinnedEvents();
  }

  Future<EventModel> getEvent(String id) async {
    final ApiResult<EventModel> apiResult = await _provider.getEvent(id);

    return apiResult.when(
        success: (List<EventModel> events) {
          return events[0];
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<List<EventModel>> getPinnedEvents(
      List<Map<String, Object?>> ids) async {
    final ApiResult<EventModel> apiResult = await _provider.getEvents();

    return apiResult.when(
        success: (List<EventModel> events) async {
          return await Stream.fromIterable(ids).asyncMap((id) async {
            return events.firstWhere((event) => event.id == id['id']);
          }).toList();
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<List<EventModel>> searchEvents(String term) async {
    final ApiResult<EventModel> apiResult = await _provider.getEvents();

    return apiResult.when(
        success: (List<EventModel> events) {
          final filteredEvents = events
              .where((event) =>
                  event.name.toLowerCase().contains(term.toLowerCase()))
              .toList();
          final int end =
              filteredEvents.length > 10 ? 10 : filteredEvents.length;
          return filteredEvents.sublist(0, end);
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }
}
