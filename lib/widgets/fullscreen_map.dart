import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class FullScreenStaticMap extends StatelessWidget {
  final dynamic location;
  FullScreenStaticMap({Key? key, required this.location});

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: InteractiveViewer(
            constrained: true,
            child: StaticMap(
              width: width,
              height: height,
              googleApiKey: "AIzaSyANhL5uys4sdZCmXRTE5hUOKHQyh0EHdE0",
              center: location,
              markers: <Marker>[
                Marker(locations: [location])
              ],
            )));
  }
}
