import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skool_app/models/events/event_model.dart';
import 'package:skool_app/providers/events/event_provider.dart';

part 'event_cubit_state.dart';

class EventCubitCubit extends Cubit<EventCubitState> {
  final EventProvider eventProvider;

  EventCubitCubit({required this.eventProvider}) : super(EventCubitInitial());

  void getAllEvents() async {
    try {
      emit(EventListLoading());
      List<EventsModel> eventModels = await eventProvider.getAllEvents(
        1,
        10,
        'createdAt',
        ''
      );
      emit(EventListLoaded(eventModels: eventModels));
    } catch (e) {
      emit(EventListError(errorMessage: e.toString()));
    }
  }

  void getEventDetail(String id) async {
    try {
      emit(EventDetailLoading());
      EventsModel eventsModel = await eventProvider.getEventDetail(id);
      emit(EventDetailLoaded(eventModels: eventsModel));
    } catch (e) {
      emit(EventDetailError(errorMessage: e.toString()));
    }
  }
}
