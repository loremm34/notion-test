part of 'add_note_bloc.dart';

@immutable
sealed class AddNoteEvent {}

class AddNote extends AddNoteEvent {
  final NoteModel note;

  AddNote({required this.note});
}

class LoadNotes extends AddNoteEvent {}

class ToggleNote extends AddNoteEvent {
  final String noteId;

  ToggleNote({required this.noteId});
}

class DeleteNote extends AddNoteEvent {
  final String noteId;

  DeleteNote({required this.noteId});
}

class UpdateNote extends AddNoteEvent {
  final NoteModel note;

  UpdateNote({required this.note});
}
