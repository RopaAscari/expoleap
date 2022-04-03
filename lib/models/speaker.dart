import 'dart:convert';
import 'package:expoleap/models/name.dart';
import 'package:expoleap/models/social.dart';
import 'package:expoleap/models/company.dart';

import 'session.dart';

List<Speaker> speakersFromJson(List<dynamic> speakers) =>
    (speakers).map((speaker) => new Speaker.fromMap(speaker)).toList();

class Speaker {
  final int id;
  final Name name;
  final String? bio;
  final String? url;
  final String event;
  final Social social;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? label;
  final String? jobTitle;
  final Company? company;
  final String? createdAt;
  final String? updatedAt;
  final List<Session>? sessions;

  Speaker({
    this.url,
    this.bio,
    this.avatar,
    this.email,
    this.label,
    this.phone,
    this.company,
    this.jobTitle,
    this.sessions,
    this.createdAt,
    this.updatedAt,
    required this.id,
    required this.name,
    required this.event,
    required this.social,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'bio': bio,
      'email': email,
      'phone': phone,
      'event': event,
      'label': label,
      'avatar': avatar,
      'job_title': jobTitle,
      'company': company?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'social': social.toMap(),
      'name': name.toMap(),
      'sessions': sessions?.map((x) => x.toMap()).toList(),
    };
  }

  factory Speaker.fromMap(Map<String, dynamic> map) {
    return Speaker(
      id: map['id'],
      url: map['url'],
      bio: map['bio'],
      email: map['email'],
      phone: map['phone'],
      event: map['event'],
      label: map['label'],
      avatar: map['avatar'],
      jobTitle: map['job_title'],
      company: map['company'] != null ? Company.fromMap(map['company']) : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      social: Social.fromMap(map['social']),
      name: Name.fromMap(map['name']),
      sessions: map['sessions'] != null
          ? List<Session>.from(map['sessions'].map((x) => Session.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Speaker.fromJson(String source) =>
      Speaker.fromMap(json.decode(source));
}
