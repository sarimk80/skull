import 'package:skool_app/models/events/event_model.dart';
import 'package:skool_app/providers/events/event_rest_api.dart';

class EventProvider {
  late EventRestApi _eventRestApi;

  EventProvider(EventRestApi api) {
    _eventRestApi = api;
  }

  Future<List<EventsModel>> getAllEvents(int page,int limit,String sortBy,String order) {
    return _eventRestApi.getAllEvents(page,limit,sortBy,order);
  }

  Future<EventsModel> getEventDetail(String id) {
    return _eventRestApi.eventDetail(id);
  }

  Future<EventsModel> createEvent(EventsModel eventModel) {
    return _eventRestApi.createEvent(eventModel);
  }

  Future<void> deleteEvent(String id) {
    return _eventRestApi.deleteEvent(id);
  }
}
