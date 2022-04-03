import 'package:expoleap/models/sponsor.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/sponsor_api_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class SponsorRepository {
  final SponsorApiProvider _provider = new SponsorApiProvider();

  Map<String, List<Sponsor>> delegateSponsorCategories(sponsorsData) {
    Map<String, List<Sponsor>> _elements = {};

    final none = sponsorsData
        .where((element) => element.category?.name == null)
        .toList();
    final platinum = sponsorsData
        .where((element) => element.category?.name == 'Platinum')
        .toList();
    final diamond = sponsorsData
        .where((element) => element.category?.name == 'Diamond')
        .toList();
    final gold = sponsorsData
        .where((element) => element.category?.name == 'Gold')
        .toList();
    final silver = sponsorsData
        .where((element) => element.category?.name == 'Silver')
        .toList();
    final bronze = sponsorsData
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

  Future<Map<String, List<Sponsor>>> fetchSponsors(String eventId) async {
    final ApiResult<Sponsor> apiResult = await _provider.getSponsors();

    return apiResult.when(
        success: (List<Sponsor> sponsors) {
          final sponsorsData =
              sponsors.where((sponsor) => sponsor.event == eventId).toList();

          return delegateSponsorCategories(sponsorsData);
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }

  Future<Map<String, List<Sponsor>>> searchSponsors(
      List<Sponsor> sponsors, String term) async {
    final List<Sponsor> sponsorsData = sponsors
        .where((sponsor) =>
            sponsor.name.toLowerCase().contains(term.toLowerCase()))
        .toList();
    return delegateSponsorCategories(sponsorsData);
  }
}
