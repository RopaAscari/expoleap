import 'dart:convert';
import 'package:expoleap/models/session_speaker.dart';

List<Session> sessionsFromJson(dynamic sessions) =>
    (sessions as List).map((session) => new Session.fromMap(session)).toList();

class Session {
  int id;
  String? end;
  String event;
  String start;
  String title;
  String? subtitle;
  String? location;
  String? createdAt;
  String? updatedAt;
  String? description;
  List<SessionSpeaker>? participants;

  Session({
    this.end,
    this.subtitle,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.participants,
    required this.id,
    required this.event,
    required this.title,
    required this.start,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'end': end,
      'event': event,
      'start': start,
      'title': title,
      'subtitle': subtitle,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'description': description,
      'participants': participants?.map((x) => x.toMap()).toList(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      end: map['end'],
      event: map['event'],
      start: map['start'],
      title: map['title'],
      subtitle: map['subtitle'],
      location: map['location'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      description: map['description'],
      participants: map['participants'] != null
          ? List<SessionSpeaker>.from(
              map['participants'].map((x) => SessionSpeaker.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));
}
