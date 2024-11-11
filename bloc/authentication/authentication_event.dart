part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthenticationEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class CheckAuthentication extends AuthenticationEvent {}

class LogoutRequested extends AuthenticationEvent {}