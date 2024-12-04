part of 'add_note_bloc.dart';

@immutable
sealed class AddNoteState {}

final class AddNoteInitial extends AddNoteState {}

class AddNoteLoading extends AddNoteState {}

class AddNoteFailure extends AddNoteState {
  final String errorText;

  AddNoteFailure(this.errorText);
}

class AddNoteSuccess extends AddNoteState {
  final List<NoteModel> notes;

  AddNoteSuccess({required this.notes});
}
