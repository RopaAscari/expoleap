import 'package:expoleap/models/exhibitor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/state/exhibitor/exhibitor_state.dart';
import 'package:expoleap/resources/repositories/exhibitor_repository.dart';

class ExhibitorCubit extends Cubit<ExhibitorState> {
  ExhibitorCubit() : super(Idle());

  final ExhibitorRepository exhibitorRepository = new ExhibitorRepository();

  void fetchExhibitors({required String eventId}) async {
    try {
      emit(ExhibitorState.loading());
      final exhibitors = await exhibitorRepository.fetchExhibitors(eventId);
      emit(ExhibitorState.data(exhibitors: exhibitors));
    } catch (error) {
      emit(ExhibitorState.error(error: error.toString()));
    }
  }

  void searchExhibitors(
      {required List<Exhibitor> exhibitors, required String term}) async {
    try {
      final Map<String, List<Exhibitor>> response =
          await exhibitorRepository.searchExhibitors(exhibitors, term);
      emit(ExhibitorState.data(exhibitors: response));
    } catch (error) {
      emit(ExhibitorState.error(error: error.toString()));
    }
  }
}
