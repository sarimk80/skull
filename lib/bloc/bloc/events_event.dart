part of 'events_bloc.dart';

@immutable
sealed class EventsEvent {}

final class FetchEvents extends EventsEvent {}

final class FetchEventsDetail extends EventsEvent {
  final String id;

  FetchEventsDetail({required this.id});
}

final class AddEvent extends EventsEvent {
  final EventsModel eventsModel;

  AddEvent({required this.eventsModel});
}
