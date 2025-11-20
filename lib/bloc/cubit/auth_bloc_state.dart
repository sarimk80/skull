part of 'auth_bloc_cubit.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

/////
class AuthBlocLoading extends AuthBlocState {}

class AuthBlocLoaded extends AuthBlocState {
  final AuthResponse authResponse;

  AuthBlocLoaded({required this.authResponse});
}

class AuthBlocError extends AuthBlocState {
  final String errorMessage;

  AuthBlocError({required this.errorMessage});
}

////
///
///
///
class AuthSignInBlocLoading extends AuthBlocState {}

class AuthSignInBlocLoaded extends AuthBlocState {
  final AuthResponse authResponse;

  AuthSignInBlocLoaded({required this.authResponse});
}

class AuthSignInBlocError extends AuthBlocState {
  final String errorMessage;

  AuthSignInBlocError({required this.errorMessage});
}