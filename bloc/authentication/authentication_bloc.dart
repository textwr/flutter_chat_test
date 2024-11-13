import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository) : super(AuthenticationInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthentication>(_onCheckAuthentication);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    print("_onLoginRequested");
    print(state);
    try {
      print("try");
      await _authenticationRepository.login(event.username, event.password);
      emit(AuthenticationAuthenticated());
    } catch (e) {
      await Future.delayed(
          const Duration(seconds: 2)
      );
    print("catch");
    emit(AuthenticationFailure(e.toString()));
    }
  }

  Future<void> _onCheckAuthentication(CheckAuthentication event, Emitter<AuthenticationState> emit) async {
    final accessToken = await _authenticationRepository.getAccessToken();
    if (accessToken != null) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) async {
    await _authenticationRepository.clearTokens();
    emit(AuthenticationUnauthenticated());
  }
}