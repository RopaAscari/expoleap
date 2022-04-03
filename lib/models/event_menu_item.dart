import 'package:expoleap/enums/enums.dart';
import 'package:flutter/material.dart';

class EventMenuItem {
  final IconData icon;
  final String title;
  final Widget route;
  final EventRoutes eventRoute;

  EventMenuItem(
      {required this.title,
      required this.icon,
      required this.route,
      required this.eventRoute});
}
