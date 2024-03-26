part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthStateLogin extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateLogout extends AuthState {}

final class AuthStateError extends AuthState {
  final String message;

  AuthStateError(this.message);
}
