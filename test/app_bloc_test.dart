import 'package:bloc_tutorial/bloc/actions.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/models.dart';
import 'package:bloc_tutorial/apis/login_api.dart';
import 'package:bloc_tutorial/apis/notes_api.dart';

const Iterable<Note> notes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

const acceptableLoginHandle = LoginHandle(token: 'ABC');

@immutable
class DummyNotesApi implements NotesApi {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> fetchNotes({
    required LoginHandle loginHandle,
  }) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    }
    return null;
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle loginHandleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.loginHandleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        loginHandleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return loginHandleToReturn;
    }
    return null;
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of bloc should be AppState.empty()',
    build: () => AppBloc(
      loginApi: DummyLoginApi.empty(),
      notesApi: DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    verify: (bloc) => expect(
      bloc.state,
      AppState.initial(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'Can we login with correct credentials?',
    build: () => AppBloc(
      loginApi: DummyLoginApi(
        acceptedEmail: 'baz@bar.com',
        acceptedPassword: 'foo',
        loginHandleToReturn: acceptableLoginHandle,
      ),
      notesApi: DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'baz@bar.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptableLoginHandle,
        fetchedNotes: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'We should get an error when we login with incorrect credentials',
    build: () => AppBloc(
      loginApi: DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPassword: 'baz',
        loginHandleToReturn: LoginHandle(token: 'ABC'),
      ),
      notesApi: DummyNotesApi.empty(),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: 'baz@bar.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Load some notes with a valid login handle',
    build: () => AppBloc(
      loginApi: DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPassword: 'baz',
        loginHandleToReturn: LoginHandle(token: 'ABC'),
      ),
      notesApi: DummyNotesApi(
        acceptedLoginHandle: const LoginHandle(token: 'ABC'),
        notesToReturnForAcceptedLoginHandle: notes,
      ),
      acceptableLoginHandle: acceptableLoginHandle,
    ),
    act: (bloc) {
      bloc.add(
        const LoginAction(
          email: 'foo@bar.com',
          password: 'baz',
        ),
      );
      bloc.add(const LoadNotesAction());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptableLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: acceptableLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptableLoginHandle,
        fetchedNotes: notes,
      ),
    ],
  );
}
