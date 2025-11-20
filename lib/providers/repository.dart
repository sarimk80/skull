import 'package:dio/dio.dart';
import 'package:skool_app/providers/auth/auth_provider.dart';
import 'package:skool_app/providers/auth/auth_rest_api.dart';
import 'package:skool_app/providers/events/event_provider.dart';
import 'package:skool_app/providers/events/event_rest_api.dart';

class Repository extends Interceptor {
  late Dio dio;
  late AuthProvider _authProvider;
  late EventProvider _eventProvider;

  Repository() {
    dio = Dio();
    _authProvider = AuthProvider(AuthRestApi(dio));
    _eventProvider = EventProvider(EventRestApi(dio));
  }

  AuthProvider get authProvider => _authProvider;
  EventProvider get eventProvider => _eventProvider;
}
