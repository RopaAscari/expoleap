import 'dart:convert';

import 'package:expoleap/models/event.dart';

class PinnedEvents {
  List<String> pinnedEventsIds;
  List<EventModel> pinnedEvents;

  PinnedEvents({required this.pinnedEvents, required this.pinnedEventsIds});

  Map<String, dynamic> toMap() {
    return {
      'pinnedEventsIds': pinnedEventsIds,
      'pinnedEvents': pinnedEvents.map((x) => x.toMap()).toList(),
    };
  }

  factory PinnedEvents.fromMap(Map<String, dynamic> map) {
    return PinnedEvents(
      pinnedEventsIds: List<String>.from(map['pinnedEventsIds']),
      pinnedEvents: List<EventModel>.from(
          map['pinnedEvents']?.map((x) => EventModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PinnedEvents.fromJson(String source) =>
      PinnedEvents.fromMap(json.decode(source));
}
