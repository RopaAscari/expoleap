import 'dart:convert';

class Device {
  final bool active;
  final String type;
  final String event;
  final String registrationId;

  Device({
    required this.type,
    required this.event,
    required this.active,
    required this.registrationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'type': type,
      'event': event,
      'registrationId': registrationId,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      type: map['type'],
      event: map['event'],
      active: map['active'],
      registrationId: map['registrationId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));
}
