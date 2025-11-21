import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:skool_app/models/events/event_model.dart';

part 'event_rest_api.g.dart';

//https://691d4c75d58e64bf0d35a589.mockapi.io/events
@RestApi(baseUrl: 'https://691d4c75d58e64bf0d35a589.mockapi.io')
abstract class EventRestApi {
  factory EventRestApi(Dio dio, {String baseUrl}) = _EventRestApi;

  @GET('/events')
  Future<List<EventsModel>> getAllEvents(
    @Query('page') int page,
    @Query('limit') int limit
  );

  @POST('/events')
  Future<EventsModel> createEvent(@Body() EventsModel eventModel);

  @GET('/events/{id}')
  Future<EventsModel> eventDetail(@Path("id") String id);

  @DELETE('/events/{id}')
  Future<void> deleteEvent(@Path("id") String id);
}
