part of 'events_bloc.dart';

enum EventsStatus {
  initial,
  loading,
  success,
  failure,
  detailLoading,
  detailLoaded,
  detailError,
  addLoading,
  addLoaded,
  addError
}

final class EventsState extends Equatable {
  final List<EventsModel>? eventModelsList;
  final EventsModel? eventModel;
  final String? errorMessage;
  final EventsStatus? eventsStatus;

  EventsState({
    this.eventsStatus = EventsStatus.initial,
    this.eventModelsList = const <EventsModel>[],
    this.errorMessage = '',
    this.eventModel,
  });

  EventsState copyWith({
    List<EventsModel>? eventModelsList,
    EventsModel? eventModel,
    String? errorMessage,
    EventsStatus? eventsStatus,
  }) {
    return EventsState(
      eventModelsList: eventModelsList ?? this.eventModelsList,
      eventModel: eventModel ?? this.eventModel,
      errorMessage: errorMessage ?? this.errorMessage,
      eventsStatus: eventsStatus ?? this.eventsStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    eventModelsList,
    eventModel,
    eventsStatus,
    errorMessage,
  ];
}
