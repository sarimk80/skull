part of 'events_bloc.dart';

@immutable
sealed class EventsEvent {}

final class FetchEvents extends EventsEvent {
  final int page;
  final int limit;

  FetchEvents({required this.page, required this.limit});
}

final class FetchEventsDetail extends EventsEvent {
  final String id;

  FetchEventsDetail({required this.id});
}

final class AddEvent extends EventsEvent {
  final EventsModel eventsModel;

  AddEvent({required this.eventsModel});
}

final class DeleteEvent extends EventsEvent {
  final String id;

  DeleteEvent({required this.id});
}
