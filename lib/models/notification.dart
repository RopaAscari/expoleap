import 'dart:convert';

class NotificationModel {
  final String id;
  final int timeStamp;
  final String eventId;
  final String message;
  NotificationModel(
      {required this.id,
      required this.eventId,
      required this.message,
      required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'eventId': eventId,
      'timeStamp': timeStamp,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      eventId: map['eventId'],
      message: map['message'],
      timeStamp: map['timeStamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
