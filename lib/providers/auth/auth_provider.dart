import 'package:skool_app/models/auth/auth_model.dart';
import 'package:skool_app/providers/auth/auth_rest_api.dart';

class AuthProvider {
  late AuthRestApi _authRestApi;

  AuthProvider(AuthRestApi api) {
    _authRestApi = api;
  }

  Future<AuthResponse> signUpUser(AuthModel authModel) {
    return _authRestApi.signUpUser(authModel);
  }

  Future<AuthResponse> signInUser(AuthModel authModel) {
    return _authRestApi.signIn(authModel);
  }
}
