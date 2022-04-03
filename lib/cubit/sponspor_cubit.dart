import 'package:expoleap/models/sponsor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/state/sponsor/sponsor_state.dart';
import 'package:expoleap/resources/repositories/sponsor_repository.dart';

class SponsorCubit extends Cubit<SponsorState> {
  SponsorCubit() : super(Idle());
  final SponsorRepository sponsorRepository = new SponsorRepository();

  void fetchSponsors({required String eventId}) async {
    try {
      emit(SponsorState.loading());
      final sponsors = await sponsorRepository.fetchSponsors(eventId);
      emit(SponsorState.data(sponsors: sponsors));
    } catch (error) {
      emit(SponsorState.error(error: error.toString()));
    }
  }

  void searchSponsors(
      {required List<Sponsor> sponsors, required String term}) async {
    try {
      final Map<String, List<Sponsor>> response =
          await sponsorRepository.searchSponsors(sponsors, term);
      emit(SponsorState.data(sponsors: response));
    } catch (error) {
      emit(SponsorState.error(error: error.toString()));
    }
  }
}
