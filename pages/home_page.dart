import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/socket/socket_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Home Page'),
    actions: [
    IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () {
    context.read<AuthenticationBloc>().add(LogoutRequested());
    },
    ),
    ],
    ),
    body: BlocBuilder<SocketBloc, SocketState>(
      builder: (context, state) {
        if (state is SocketConnecting) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SocketConnected) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Connected to the Socket.IO server!'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<SocketBloc>().add(SocketDisconnect());
                  },
                  child: const Text('Disconnect from Socket.IO'),
                ),
              ],
            ),
          );
        } else if (state is SocketDisconnected || state is SocketInitial) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<SocketBloc>().add(SocketConnect());
              },
              child: const Text('Connect to Socket.IO'),
            ),
          );
        } else if (state is SocketError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.error}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<SocketBloc>().add(SocketConnect());
                  },
                  child: const Text('Retry Connection'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ),
    );
  }
}