import 'package:flutter/material.dart';

class MapResponse {
  final String location;
  final double latitude;
  final double longitude;
  final ImageProvider<Object> image;
  MapResponse(
      {required this.location,
      required this.latitude,
      required this.longitude,
      required this.image});
}
