part of 'socket_bloc.dart';

abstract class SocketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SocketConnect extends SocketEvent {}

class SocketDisconnect extends SocketEvent {}