import 'package:expoleap/models/speaker.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/speaker_api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class SpeakerRepository {
  final SpeakerApiProvider _provider = new SpeakerApiProvider();
  Future<List<Speaker>> fetchSpeakers(String eventId) async {
    final ApiResult<Speaker> apiResult = await _provider.getSpeakers();

    return apiResult.when(
        success: (List<Speaker> speakers) {
          return speakers.where((speaker) => speaker.event == eventId).toList();
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<Speaker> fetchSpeaker(int speakerId) async {
    final ApiResult<Speaker> apiResult = await _provider.getSpeakers();

    return apiResult.when(
        success: (List<Speaker> speakers) {
          return speakers.firstWhere((speaker) => speaker.name.id == speakerId);
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<List<Speaker>> searchSpeakers(
      List<Speaker> speakers, String term) async {
    return speakers.where((speaker) {
      final String name =
          '${speaker.name.title} ${speaker.name.first} ${speaker.name.last}';

      return name.toLowerCase().contains(term.toLowerCase());
    }).toList();
  }
}
