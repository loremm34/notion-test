part of 'add_note_bloc.dart';

@immutable
sealed class AddNoteEvent {}

// ивент добавления задачи
class AddNote extends AddNoteEvent {
  final NoteModel note;

  AddNote({required this.note});
}

// ивент загрузки задач
class LoadNotes extends AddNoteEvent {}

// ивент смены статуса задачи
class ToggleNote extends AddNoteEvent {
  final String noteId;

  ToggleNote({required this.noteId});
}

// ивент удаления задачи
class DeleteNote extends AddNoteEvent {
  final String noteId;

  DeleteNote({required this.noteId});
}

// ивент обновления задачи
class UpdateNote extends AddNoteEvent {
  final NoteModel note;

  UpdateNote({required this.note});
}
