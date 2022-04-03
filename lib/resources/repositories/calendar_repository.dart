import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:expoleap/utils/utils.dart';
import 'package:expoleap/models/calendar.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:expoleap/resources/api_result/api_result.dart';
import 'package:expoleap/resources/providers/api/calendar_provider.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';

class CalendarRepository {
  final CalendarApiProvider _provider = new CalendarApiProvider();

  Future<Map<DateTime, List<Calendar>>> fetchCalendarEvents() async {
    final ApiResult<CalendarEvent> apiResult =
        await _provider.getCalenderEvents();

    return apiResult.when(
        success: (List<CalendarEvent> events) {
          Map<DateTime, List<Calendar>> dates = {};
          DateFormat format = DateFormat("yyyy-MM-dd");

          events.forEach((event) {
            final String dateString = event.originalStart.split('T')[0];
            DateTime formattedDate = format.parse(dateString);

            final DateTime date = new DateTime(
                formattedDate.year, formattedDate.month, formattedDate.day);

            final Widget dot = Container(
                margin: const EdgeInsets.only(top: 10),
                child:
                    Icon(Icons.circle, color: HexColor(event.color), size: 10));

            dates.putIfAbsent(
                date,
                () => [
                      new Calendar(
                          dot: dot,
                          date: date,
                          title: event.title,
                          color: event.color,
                          event: event.event,
                          id: event.calendar,
                          owner: event.owner,
                          reminder: event.reminder,
                          calendarDate: event.date,
                          location: event.location,
                          calendar: event.calendar,
                          recurrence: event.recurrence,
                          description: event.description,
                          participants: event.participants,
                          originalStart: event.originalStart,
                          originalTimezone: event.originalTimezone)
                    ]);
          });
          return dates;
        },
        failure: (NetworkExceptions ex) =>
            throw NetworkExceptions.getErrorMessage(ex));
  }
}
