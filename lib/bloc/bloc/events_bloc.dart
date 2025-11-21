import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skool_app/models/events/event_model.dart';
import 'package:equatable/equatable.dart';
import 'package:skool_app/providers/events/event_provider.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'events_event.dart';
part 'events_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventProvider eventProvider;
  EventsBloc({required this.eventProvider})
    : super(EventsState(eventsStatus: EventsStatus.initial)) {
    on<FetchEvents>(_onFetchEvent);
    on<FetchEventsDetail>(_onFetchEventDetail);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onFetchEvent(
    FetchEvents event,
    Emitter<EventsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      List<EventsModel> eventModels = await eventProvider.getAllEvents(
        event.page,
        event.limit,
        'createdAt',
        'asc',
      );

      if (eventModels.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }
      // Sort events by createdAt in descending order (newest first)
      // eventModels.sort((a, b) {
      //   final dateA = DateTime.tryParse(a.createdAt ?? '');
      //   final dateB = DateTime.tryParse(b.createdAt ?? '');

      //   if (dateA == null && dateB == null) return 0;
      //   if (dateA == null) return 1; // Put null dates at the end
      //   if (dateB == null) return -1; // Put null dates at the end

      //   return dateB.compareTo(dateA); // Descending order (newest first)
      // });

      emit(
        state.copyWith(
          eventModelsList: [...state.eventModelsList ?? [], ...eventModels],
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
      //listOfEvents.add(eventsModel);
      listOfEvents.insert(0, eventsModel);
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

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(eventsStatus: EventsStatus.deleteLoading));
    try {
      await eventProvider.deleteEvent(event.id);

      emit(
        state.copyWith(
          eventModelsList: state.eventModelsList,
          eventsStatus: EventsStatus.deleteLoaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          eventsStatus: EventsStatus.deleteError,
        ),
      );
    }
  }
}
