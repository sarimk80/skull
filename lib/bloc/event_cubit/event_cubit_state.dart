part of 'event_cubit_cubit.dart';

@immutable
sealed class EventCubitState {}

final class EventCubitInitial extends EventCubitState {}

class EventListLoading extends EventCubitState {}

class EventListLoaded extends EventCubitState {
  final List<EventsModel> eventModels;

  EventListLoaded({required this.eventModels});
}

class EventListError extends EventCubitState {
  final String errorMessage;

  EventListError({required this.errorMessage});
}

class EventDetailLoading extends EventCubitState {}

class EventDetailLoaded extends EventCubitState {
  final EventsModel eventModels;

  EventDetailLoaded({required this.eventModels});
}

class EventDetailError extends EventCubitState {
  final String errorMessage;

  EventDetailError({required this.errorMessage});
}
