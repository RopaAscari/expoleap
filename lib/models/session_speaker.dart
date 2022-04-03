import 'dart:convert';
import 'package:expoleap/models/name.dart';

class SessionSpeaker {
  final int id;
  final Name name;
  final String? title;
  final String? avatar;

  SessionSpeaker(
      {required this.id, required this.name, this.title, this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'name': name.toMap(),
      'title': title,
      'avatar': avatar,
    };
  }

  factory SessionSpeaker.fromMap(Map<String, dynamic> map) {
    return SessionSpeaker(
      id: map['id'],
      name: Name.fromMap(map['name']),
      title: map['title'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionSpeaker.fromJson(String source) =>
      SessionSpeaker.fromMap(json.decode(source));
}
