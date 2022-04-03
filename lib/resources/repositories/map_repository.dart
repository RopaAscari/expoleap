import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:expoleap/models/map.dart';
import 'package:expoleap/models/address.dart';
import 'package:geocoding/geocoding.dart' as Geocoder;
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as StaticMap;

class MapRepository {
  Future<MapResponse> generateLocationDisplay(Address address) async {
    try {
      final String key = dotenv.get('GOOGLE_API_KEY');
      final String eLocation =
          '${address.address1}, ${address.address2}, ${address.region}';
      List<Location> locations = await Geocoder.locationFromAddress(eLocation);
      final staticLocation =
          StaticMap.Location(locations[0].latitude, locations[0].longitude);
      StaticMap.StaticMapController _controller = StaticMap.StaticMapController(
          googleApiKey: key,
          width: 475,
          height: 300,
          zoom: 10,
          styles: <StaticMap.MapStyle>[],
          center: staticLocation,
          markers: [
            StaticMap.Marker(locations: [staticLocation])
          ]);

      return new MapResponse(
          location: eLocation,
          latitude: locations[0].latitude,
          longitude: locations[0].longitude,
          image: _controller.image);
    } catch (err) {
      return err as dynamic;
    }
  }
}
