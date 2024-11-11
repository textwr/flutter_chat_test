import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:equatable/equatable.dart';

import '../../repositories/authentication_repository.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final AuthenticationRepository _authRepository;
  late IO.Socket socket;

  SocketBloc(this._authRepository) : super(SocketInitial()) {
    on<SocketConnect>(_onSocketConnect);
    on<SocketDisconnect>(_onSocketDisconnect);
  }

  Future<void> _onSocketConnect(SocketConnect event, Emitter<SocketState> emit) async {
    emit(SocketConnecting());
    try {
      final accessToken = await _authRepository.getAccessToken();
      if (accessToken == null) {
        emit(SocketDisconnected());
        return;
      }

      socket = IO.io('http://hitto.synology.me:9000', <String, dynamic>{
        'transports': ['websocket'],
        'auth': {'token': accessToken},
      });

      socket.onConnect((_) {
        emit(SocketConnected());
      });

      socket.onDisconnect((_) {
        emit(SocketDisconnected());
      });

      socket.connect();
    } catch (e) {
      emit(SocketError(e.toString()));
    }
  }

  Future<void> _onSocketDisconnect(SocketDisconnect event, Emitter<SocketState> emit) async {
    socket.disconnect();
    emit(SocketDisconnected());
  }
}