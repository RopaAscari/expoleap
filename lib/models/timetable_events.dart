import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:expoleap/models/session.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimetableEvent {
  TimetableEvent({
    required this.to,
    required this.from,
    this.session,
    this.isAllDay = false,
    required this.eventName,
    this.background = Colors.green,
  });

  DateTime to;
  DateTime from;
  bool isAllDay;
  Session? session;
  String eventName;
  Color background;
}

class TimetableDataSource extends CalendarDataSource {
  TimetableDataSource(List<TimetableEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}
