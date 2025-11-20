import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skool_app/models/events/event_model.dart';
import 'package:equatable/equatable.dart';
import 'package:skool_app/providers/events/event_provider.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventProvider eventProvider;
  EventsBloc({required this.eventProvider}) : super(EventsState()) {
    on<FetchEvents>(_onFetchEvent);
    on<FetchEventsDetail>(_onFetchEventDetail);
    on<AddEvent>(_onAddEvent);
  }

  Future<void> _onFetchEvent(
    FetchEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(eventsStatus: EventsStatus.loading));
    try {
      List<EventsModel> eventModels = await eventProvider.getAllEvents();
      emit(
        state.copyWith(
          eventModelsList: eventModels,
          eventsStatus: EventsStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          eventsStatus: EventsStatus.failure,
        ),
      );
    }
  }

  Future<void> _onFetchEventDetail(
    FetchEventsDetail event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(eventsStatus: EventsStatus.detailLoading));
    try {
      EventsModel eventModels = await eventProvider.getEventDetail(event.id);
      emit(
        state.copyWith(
          eventModelsList: state.eventModelsList,
          eventModel: eventModels,
          eventsStatus: EventsStatus.detailLoaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          eventsStatus: EventsStatus.detailError,
        ),
      );
    }
  }

  Future<void> _onAddEvent(AddEvent event, Emitter<EventsState> emit) async {
    emit(state.copyWith(eventsStatus: EventsStatus.addLoading));
    try {
      EventsModel eventsModel = await eventProvider.createEvent(
        event.eventsModel,
      );
      List<EventsModel> listOfEvents = state.eventModelsList ?? [];
      listOfEvents.add(eventsModel);
      emit(
        state.copyWith(
          eventModelsList: listOfEvents,
          eventModel: eventsModel,
          eventsStatus: EventsStatus.addLoaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          eventsStatus: EventsStatus.addError,
        ),
      );
    }
  }
}
