import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/auth/auth_provider.dart';
import 'package:bloc_tutorial/auth/auth_error.dart';
import 'package:bloc_tutorial/auth/auth_user.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/storage/storage_service.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthProvider authProvider;
  final StorageService storageService;

  AppBloc({
    required this.authProvider,
    required this.storageService,
  }) : super(const AppStateLoggedOut(isLoading: false)) {
    // Navigate to Registration
    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });

    // Handle Login
    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));

      try {
        final AuthUser user = await authProvider.login(
          email: event.email,
          password: event.password,
        );

        final images = await storageService.getUserImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      } on AuthError catch (e) {
        emit(AppStateLoggedOut(isLoading: false, error: e));
      }
    });

    // Navigate to Login
    on<AppEventGoToLogin>((event, emit) {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // Handle Registration
    on<AppEventRegister>((event, emit) async {
      emit(const AppStateIsInRegistrationView(isLoading: true));

      try {
        final AuthUser user = await authProvider.createUser(
          email: event.email,
          password: event.password,
        );
        await authProvider.login(email: event.email, password: event.password);

        emit(AppStateLoggedIn(isLoading: false, user: user, images: []));
      } on AuthError catch (e) {
        emit(AppStateIsInRegistrationView(isLoading: false, error: e));
      }
    });

    // Initialize App
    on<AppEventInitialize>((event, emit) async {
      await authProvider.initialize();
      final AuthUser? user = await authProvider.getCurrentUser();

      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
      } else {
        final images = await storageService.getUserImages(user.uid);
        emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
      }
    });

    // Handle Logout
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      await authProvider.logout();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // Handle Image Upload
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
          return;
        }

        emit(AppStateLoggedIn(
            isLoading: true, user: user, images: state.images ?? []));

        final file = File(event.filePathToUpload);
        final fileId = await storageService.uploadImage(
          userId: user.uid,
          filePath: file.path,
        );

        if (fileId != null) {
          final images = await storageService.getUserImages(user.uid);
          emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
        } else {
          emit(AppStateLoggedIn(
              isLoading: false, user: user, images: state.images ?? []));
        }
      },
    );
  }
}
