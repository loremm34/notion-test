part of 'add_note_bloc.dart';

@immutable
sealed class AddNoteState {}

final class AddNoteInitial extends AddNoteState {}

// состояние загрузки
class AddNoteLoading extends AddNoteState {}

// состояние после ошибки загрузки
class AddNoteFailure extends AddNoteState {
  final String errorText;

  AddNoteFailure(this.errorText);
}

// состояние успешной загрузки
class AddNoteSuccess extends AddNoteState {
  final List<NoteModel> notes;

  AddNoteSuccess({required this.notes});
}
