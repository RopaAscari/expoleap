import 'dart:convert';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/address.dart';

class EventModel {
  final String id;
  final String name;
  final String? logo;
  final String? icon;
  final String? owner;
  final Social social;
  final String? email;
  final String? phone;
  final Address address;
  final String? website;
  final String timezone;
  final String? location;
  final String? createdAt;
  final String? updatedAt;
  final String? description;
  final List<EventDate> dates;

  EventModel({
    this.logo,
    this.icon,
    this.owner,
    this.email,
    this.phone,
    this.website,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.description,
    required this.id,
    required this.name,
    required this.dates,
    required this.social,
    required this.address,
    required this.timezone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'icon': icon,
      'location': location,
      'timezone': timezone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'social': social.toMap(),
      'description': description,
      'address': address.toMap(),
      'dates': dates.map((x) => x.toMap()).toList(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      name: map['name'],
      logo: map['logo'],
      icon: map['icon'],
      location: map['location'],
      timezone: map['timezone'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      social: Social.fromMap(map['social']),
      description: map['description'],
      address: Address.fromMap(map['address']),
      dates:
          List<EventDate>.from(map['dates']?.map((x) => EventDate.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));
}

List<EventModel> eventsFromJson(List<dynamic> events) =>
    (events).map((event) => new EventModel.fromMap(event)).toList();

EventModel eventFromJson(Map<String, dynamic> event) =>
    new EventModel.fromMap(event);

class EventDate {
  final int id;
  final String start;
  final String end;

  EventDate({required this.id, required this.start, required this.end});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start,
      'end': end,
    };
  }

  factory EventDate.fromMap(Map<String, dynamic> map) {
    return EventDate(
      id: map['id'],
      start: map['start'],
      end: map['end'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventDate.fromJson(String source) =>
      EventDate.fromMap(json.decode(source));
}

class EventTimeMetaData {
  final int startTime;
  final String createdAt;
  final String updatedAt;
  final String timezone;

  EventTimeMetaData(
      {required this.startTime,
      required this.createdAt,
      required this.updatedAt,
      required this.timezone});
}
