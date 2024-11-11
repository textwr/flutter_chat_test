import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/socket/socket_bloc.dart';
import 'repositories/authentication_repository.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  final authenticationRepository = AuthenticationRepository();
  runApp(MyApp(authenticationRepository));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  MyApp(this._authenticationRepository);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(_authenticationRepository)
            ..add(CheckAuthentication()),
        ),
        BlocProvider(
          create: (context) => SocketBloc(_authenticationRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Socket.IO Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationLoading || state is AuthenticationInitial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthenticationAuthenticated) {
                return HomePage();
              } else {
                return LoginPage();
              }
            },
          ),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}