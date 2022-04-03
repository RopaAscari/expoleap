import 'package:expoleap/models/map.dart';
import 'package:expoleap/models/address.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expoleap/state/map/map_state.dart';
import 'package:expoleap/resources/repositories/map_repository.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(Idle());

  final MapRepository mapRepository = new MapRepository();

  void fetchMapFromAddress({required Address address}) async {
    try {
      emit(MapState.loading());
      final MapResponse response =
          await mapRepository.generateLocationDisplay(address);
      emit(MapState.data(data: response));
    } catch (err) {
      emit(MapState.error(error: 'Map could not be loaded'));
    }
  }
}
