import 'package:notion_test/data/models/note_model.dart';

// абстрактный класс для работы с cloud firestore
abstract class FirestoreRepository {
  Future<void> addNote(NoteModel note);
  Future<void> deleteNote(String noteId);
  Future<void> updateNote(NoteModel note);
  Future<List<NoteModel>> fetchNotes();
}
