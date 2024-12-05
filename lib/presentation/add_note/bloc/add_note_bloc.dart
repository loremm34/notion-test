import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notion_test/data/models/note_model.dart';
import 'package:notion_test/services/firestore_service.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final _firestoreService = FirestoreService();
  final List<NoteModel> _notes = [];

  AddNoteBloc() : super(AddNoteInitial()) {
    on<AddNote>(_onAddNote);
    on<LoadNotes>(_onLoadNotes);
    on<ToggleNote>(_onToggleNote);
  }

  Future<void> _onAddNote(
    AddNote event,
    Emitter<AddNoteState> emit,
  ) async {
    emit(AddNoteLoading());
    try {
      await _firestoreService.addNote(event.note);
      _notes.add(event.note);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      emit(AddNoteFailure('Error while adding a note'));
      log('$e');
    }
  }

  Future<void> _onLoadNotes(
    LoadNotes event,
    Emitter<AddNoteState> emit,
  ) async {
    emit(AddNoteLoading());
    try {
      final notes = await _firestoreService.fetchNotes();
      _notes.clear();
      _notes.addAll(notes);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      emit(AddNoteFailure('Failed while fetching notes'));
      log('$e');
    }
  }

  Future<void> _onToggleNote(
    ToggleNote event,
    Emitter<AddNoteState> emit,
  ) async {
    try {
      final note = _notes.firstWhere((note) => note.id == event.notId);
      note.isCompleted = !note.isCompleted;

      await _firestoreService.updateNote(note);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      log('$e');
      emit(AddNoteFailure('Failed while toggle notes'));
    }
  }
}
