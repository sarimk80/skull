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
  addError,
  deleteLoading,
  deleteLoaded,
  deleteError
}

final class EventsState extends Equatable {
  final List<EventsModel>? eventModelsList;
  final EventsModel? eventModel;
  final String? errorMessage;
  final EventsStatus? eventsStatus;
  final bool hasReachedMax;

  EventsState({
    this.eventsStatus = EventsStatus.initial,
    this.eventModelsList = const <EventsModel>[],
    this.errorMessage = '',
    this.eventModel,
    this.hasReachedMax = false
  });

  EventsState copyWith({
    List<EventsModel>? eventModelsList,
    EventsModel? eventModel,
    String? errorMessage,
    EventsStatus? eventsStatus,
    bool? hasReachedMax,
  }) {
    return EventsState(
      eventModelsList: eventModelsList ?? this.eventModelsList,
      eventModel: eventModel ?? this.eventModel,
      errorMessage: errorMessage ?? this.errorMessage,
      eventsStatus: eventsStatus ?? this.eventsStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    eventModelsList,
    eventModel,
    eventsStatus,
    errorMessage,
    hasReachedMax
  ];
}
