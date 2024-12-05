part of 'add_note_bloc.dart';

@immutable
sealed class AddNoteEvent {}

class AddNote extends AddNoteEvent {
  final NoteModel note;

  AddNote({required this.note});
}

class LoadNotes extends AddNoteEvent {}

class ToggleNote extends AddNoteEvent {
  final String notId;

  ToggleNote({required this.notId});
}
