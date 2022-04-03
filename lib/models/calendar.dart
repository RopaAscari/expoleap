import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

List<CalendarEvent> calendarsFromJson(List<dynamic> events) =>
    (events).map((event) => new CalendarEvent.fromMap(event)).toList();

class Calendar extends Event {
  int? id;
  int event;
  Widget? dot;
  Widget? icon;
  String color;
  int calendar;
  String owner;
  String? title;
  DateTime date;
  String location;
  Reminder reminder;
  String? calendarId;
  String description;
  String originalStart;
  Recurrence recurrence;
  String originalTimezone;
  CalendarDate calendarDate;
  List<Participant> participants;

  Calendar({
    this.dot,
    this.icon,
    this.title,
    required this.id,
    required this.date,
    required this.event,
    required this.color,
    required this.owner,
    required this.location,
    required this.calendar,
    required this.reminder,
    required this.recurrence,
    required this.description,
    required this.calendarDate,
    required this.participants,
    required this.originalStart,
    required this.originalTimezone,
  }) : super(date: date);
}

class CalendarEvent {
  String? id;
  int event;
  String title;
  String color;
  int calendar;
  String owner;
  String location;
  CalendarDate date;
  Reminder reminder;
  String description;
  Recurrence recurrence;
  String originalStart;
  String originalTimezone;

  List<Participant> participants;
  CalendarEvent({
    required this.id,
    required this.event,
    required this.date,
    required this.color,
    required this.owner,
    required this.title,
    required this.location,
    required this.calendar,
    required this.reminder,
    required this.description,
    required this.recurrence,
    required this.participants,
    required this.originalStart,
    required this.originalTimezone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event,
      'title': title,
      'color': color,
      'calendar': calendar,
      'owner': owner,
      'location': location,
      'date': date.toMap(),
      'reminder': reminder.toMap(),
      'description': description,
      'recurrence': recurrence.toMap(),
      'originalStart': originalStart,
      'originalTimezone': originalTimezone,
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'],
      event: map['event'],
      title: map['title'],
      color: map['color'],
      calendar: map['calendar'],
      owner: map['owner'],
      location: map['location'],
      date: CalendarDate.fromMap(map['date']),
      reminder: Reminder.fromMap(map['reminder']),
      description: map['description'],
      recurrence: Recurrence.fromMap(map['recurrence']),
      originalStart: map['original_start'],
      originalTimezone: map['original_timezone'],
      participants: List<Participant>.from(
          map['participants']?.map((x) => Participant.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarEvent.fromJson(String source) =>
      CalendarEvent.fromMap(json.decode(source));
}

class CalendarDate {
  String start;
  String end;
  String timezone;
  CalendarDate(
      {required this.start, required this.end, required this.timezone});

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'timezone': timezone,
    };
  }

  factory CalendarDate.fromMap(Map<String, dynamic> map) {
    return CalendarDate(
      start: map['start'],
      end: map['end'],
      timezone: map['timezone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarDate.fromJson(String source) =>
      CalendarDate.fromMap(json.decode(source));
}

class Reminder {
  bool enabled;
  int minutes;
  Reminder({required this.enabled, required this.minutes});

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'minutes': minutes,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      enabled: map['enabled'],
      minutes: map['minutes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
}

class Recurrence {
  bool enabled;
  List rules;

  Recurrence({required this.enabled, required this.rules});

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'rules': rules,
    };
  }

  factory Recurrence.fromMap(Map<String, dynamic> map) {
    return Recurrence(
      enabled: map['enabled'],
      rules: List.from(map['rules']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Recurrence.fromJson(String source) =>
      Recurrence.fromMap(json.decode(source));
}

class Attendee {
  int id;
  String email;
  String firstName;
  String lastName;

  Attendee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }

  factory Attendee.fromMap(Map<String, dynamic> map) {
    return Attendee(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Attendee.fromJson(String source) =>
      Attendee.fromMap(json.decode(source));
}

class Participant {
  Attendee attendee;
  int rsvpStatus;

  Participant({required this.attendee, required this.rsvpStatus});

  Map<String, dynamic> toMap() {
    return {
      'attendee': attendee.toMap(),
      'rsvp_status': rsvpStatus,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      attendee: Attendee.fromMap(map['attendee']),
      rsvpStatus: map['rsvp_status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source));
}
