import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:expoleap/models/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_state.freezed.dart';

@freezed
class EventState<T> with _$EventState<T> {
  const factory EventState.idle() = Idle<T>;

  const factory EventState.loading() = Loading<T>;

  const factory EventState.error({@Default('') String error}) = Error<T>;

  const factory EventState.data({@Default([]) List<EventModel> data}) = Data<T>;
}






















/*class EventState extends Equatable {
  final List<EventModel> pinnedEvents;

  const EventState({required this.pinnedEvents});
  @override
  List<Object> get props => [];
}

class SearchEventResults extends EventState {
  final List<EventModel> searchedEvents;

  SearchEventResults({
    required this.searchedEvents,
  }) : super(pinnedEvents: []);

  @override
  List<Object> get props => [searchedEvents];
}

class SearchResultsEmpty extends EventState {
  SearchResultsEmpty() : super(pinnedEvents: []);
}

class SearchEventError extends EventState {
  final String error;
  SearchEventError({required this.error}) : super(pinnedEvents: []);

  @override
  List<Object> get props => [error];
}

class SearchEventLoading extends EventState {
  SearchEventLoading() : super(pinnedEvents: []);
}

class EventFetchLoading extends EventState {
  EventFetchLoading() : super(pinnedEvents: []);
}

class EventFetched extends EventState {
  final EventModel event;

  EventFetched({
    required this.event,
  }) : super(pinnedEvents: []);

  @override
  List<Object> get props => [event];
}*/
