import 'package:bloc_tutorial/models.dart' show LoginHandle, Note, mockNotes;
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> fetchNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NotesApiProtocol {
  const NotesApi._sharedInstance();

  static const NotesApi _shared = NotesApi._sharedInstance();
  factory NotesApi.instance() => _shared;
  @override
  Future<Iterable<Note>?> fetchNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}
