import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:skool_app/models/auth/auth_model.dart';
import 'package:skool_app/providers/auth/auth_provider.dart';

part 'auth_bloc_state.dart';

class AuthBlocCubit extends Cubit<AuthBlocState> {
  final AuthProvider authProvider;

  AuthBlocCubit({required this.authProvider}) : super(AuthBlocInitial());

  final userBox = Hive.box('skool');

  void signUp(AuthModel authModel) async {
    emit(AuthBlocLoading());
    try {
      AuthResponse response = await authProvider.signUpUser(authModel);
      userBox.put('userId', response.token);
      emit(AuthBlocLoaded(authResponse: response));
    } catch (e) {
      emit(AuthBlocError(errorMessage: e.toString()));
    }
  }

  void signIn(AuthModel authModel) async {
    emit(AuthSignInBlocLoading());
    try {
      AuthResponse response = await authProvider.signInUser(authModel);
      userBox.put('userId', response.token);
      emit(AuthSignInBlocLoaded(authResponse: response));
    } catch (e) {
      emit(AuthSignInBlocError(errorMessage: e.toString()));
    }
  }
}
