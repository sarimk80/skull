import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:skool_app/models/auth/auth_model.dart';

part 'auth_rest_api.g.dart';

//https://reqres.in/api/register
//https://reqres.in/api/login
@RestApi(
  baseUrl: 'https://reqres.in',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-api-key': 'reqres-free-v1',
  },
)
abstract class AuthRestApi {
  factory AuthRestApi(Dio dio, {String baseUrl}) = _AuthRestApi;

  @POST('/api/register')
  Future<AuthResponse> signUpUser(@Body() AuthModel authModel);

  @POST('/api/login')
  Future<AuthResponse> signIn(@Body() AuthModel authModel);
}
