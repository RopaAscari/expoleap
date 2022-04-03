import 'package:expoleap/models/exhibitor.dart';
import 'package:expoleap/resources/api_result/api_result.dart';

import 'package:expoleap/resources/providers/api/exhibitor_api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class ExhibitorRepository {
  final ExhibitorApiProvider _provider = new ExhibitorApiProvider();

  Map<String, List<Exhibitor>> delegateExhibitorCategories(
      List<Exhibitor> exhibitorData) {
    Map<String, List<Exhibitor>> _elements = {};

    final none = exhibitorData.where((element) {
      return element.category?.name == null;
    }).toList();

    final platinum = exhibitorData
        .where((element) => element.category?.name == 'Platinum')
        .toList();
    final diamond = exhibitorData
        .where((element) => element.category?.name == 'Diamond')
        .toList();
    final gold = exhibitorData
        .where((element) => element.category?.name == 'Gold')
        .toList();
    final silver = exhibitorData
        .where((element) => element.category?.name == 'Silver')
        .toList();
    final bronze = exhibitorData
        .where((element) => element.category?.name == 'Bronze')
        .toList();

    if (none.length > 0) {
      _elements.putIfAbsent('None', () => none);
    }

    if (platinum.length > 0) {
      _elements.putIfAbsent('Platinum', () => platinum);
    }

    if (diamond.length > 0) {
      _elements.putIfAbsent('Diamond', () => diamond);
    }

    if (gold.length > 0) {
      _elements.putIfAbsent('Gold', () => gold);
    }

    if (silver.length > 0) {
      _elements.putIfAbsent('Silver', () => silver);
    }

    if (bronze.length > 0) {
      _elements.putIfAbsent('Bronze', () => bronze);
    }

    return _elements;
  }

  Future<Map<String, List<Exhibitor>>> fetchExhibitors(String eventId) async {
    final ApiResult<Exhibitor> apiResult = await _provider.getExhibitors();
    return apiResult.when(success: (List<Exhibitor> exhibitors) {
      final exhibitorData =
          exhibitors.where((exhibitor) => exhibitor.event == eventId).toList();
      return delegateExhibitorCategories(exhibitorData);
    }, failure: (NetworkExceptions ex) {
      throw NetworkExceptions.getErrorMessage(ex);
    });
  }

  Future<Map<String, List<Exhibitor>>> searchExhibitors(
      List<Exhibitor> sponsors, String term) async {
    final List<Exhibitor> sponsorsData = sponsors
        .where((sponsor) =>
            sponsor.name.toLowerCase().contains(term.toLowerCase()))
        .toList();
    return delegateExhibitorCategories(sponsorsData);
  }
}
