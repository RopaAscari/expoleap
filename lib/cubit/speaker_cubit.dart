import 'package:expoleap/models/speaker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/state/speaker/speaker_state.dart';
import 'package:expoleap/resources/repositories/speaker_repository.dart';

class SpeakerCubit extends Cubit<SpeakerState> {
  SpeakerCubit() : super(Idle());

  final SpeakerRepository speakerRepository = new SpeakerRepository();
  void fetchSpeakers({required String eventId}) async {
    try {
      emit(SpeakerState.loading());
      final speakers = await speakerRepository.fetchSpeakers(eventId);
      emit(SpeakerState.data(speakers: speakers));
    } catch (error) {
      emit(SpeakerState.error(error: error.toString()));
    }
  }

  void searchSpeakers(
      {required List<Speaker> speakers, required String term}) async {
    try {
      final List<Speaker> response =
          await speakerRepository.searchSpeakers(speakers, term);
      emit(SpeakerState.data(speakers: response));
    } catch (error) {
      emit(SpeakerState.error(error: error.toString()));
    }
  }
}
