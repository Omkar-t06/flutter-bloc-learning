import 'package:bloc_tutorial/auth/auth_service.dart';
import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/dialog/show_auth_error.dart';
import 'package:bloc_tutorial/loader/loading_screen.dart';
import 'package:bloc_tutorial/storage/storage_service.dart';
import 'package:bloc_tutorial/views/login_view.dart';
import 'package:bloc_tutorial/views/photo_gallery_view.dart';
import 'package:bloc_tutorial/views/registratrion_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc(
        authProvider: AuthService.appwrite(),
        storageService: StorageService(),
      )..add(const AppEventInitialize()),
      child: MaterialApp(
          title: 'Photo Library',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, appState) {
        if (appState.isLoading) {
          LoadingScreen.instance().show(
            context: context,
            text: "Loading...",
          );
        } else {
          LoadingScreen.instance().hide();
        }

        final authError = appState.error;
        if (authError != null) {
          showAuthError(authError: authError, context: context);
        }
      },
      builder: (context, appState) {
        if (appState is AppStateLoggedOut) {
          return LoginView();
        } else if (appState is AppStateLoggedIn) {
          return PhotoGalleryView();
        } else if (appState is AppStateIsInRegistrationView) {
          return RegistrationView();
        } else {
          return Container();
        }
      },
    );
  }
}
