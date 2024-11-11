part of 'socket_bloc.dart';

abstract class SocketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SocketInitial extends SocketState {}

class SocketConnecting extends SocketState {}

class SocketConnected extends SocketState {}

class SocketDisconnected extends SocketState {}

class SocketError extends SocketState {
  final String error;

  SocketError(this.error);

  @override
  List<Object?> get props => [error];
}