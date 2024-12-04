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
    on<AddNote>((event, emit) async {
      emit(AddNoteLoading());

      try {
        await _firestoreService.addNote(event.note);
        _notes.add(event.note);
        emit(AddNoteSuccess(notes: List.from(_notes)));
      } catch (e) {
        emit(AddNoteFailure('Error while adding a note'));
        log('$e');
      }
    });
  }
}
