import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/apis/login_api.dart';
import 'package:bloc_tutorial/apis/notes_api.dart';
import 'package:bloc_tutorial/bloc/actions.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.initial()) {
    on<LoginAction>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);

      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });
    on<LoadNotesAction>(
      (event, emit) async {
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
        } else {
          final notes = await notesApi.fetchNotes(loginHandle: loginHandle!);
          emit(
            AppState(
              isLoading: false,
              loginError: null,
              loginHandle: loginHandle,
              fetchedNotes: notes,
            ),
          );
        }
      },
    );
  }
}
