import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notion_test/data/models/note_model.dart';
import 'package:notion_test/services/firestore_service.dart';
import 'package:notion_test/services/notification_service.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final _firestoreService = FirestoreService();
  final _notificationService = NotificationService();
  final List<NoteModel> _notes = [];

  AddNoteBloc() : super(AddNoteInitial()) {
    on<AddNote>(_onAddNote);
    on<LoadNotes>(_onLoadNotes);
    on<ToggleNote>(_onToggleNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
  }
// добавление задачи и установление уведомления
  Future<void> _onAddNote(
    AddNote event,
    Emitter<AddNoteState> emit,
  ) async {
    emit(AddNoteLoading());
    try {
      await _firestoreService.addNote(event.note);
      _notes.add(event.note);
      _notificationService.scheduleNotification(
          event.note.date, event.note.title);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      emit(AddNoteFailure('Error while adding a note'));
      log('$e');
    }
  }

  // загрузка задач
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

  // обновление задач
  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<AddNoteState> emit,
  ) async {
    try {
      emit(AddNoteLoading());

      await _firestoreService.updateNote(event.note);

      final index = _notes.indexWhere((note) => note.id == event.note.id);
      if (index != -1) {
        _notes[index] = event.note;
      }

      _notificationService.scheduleNotification(
          event.note.date, event.note.title);

      emit(AddNoteSuccess(notes: List.from(_notes)));
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      emit(AddNoteFailure('Failed while fetching notes'));
      log('$e');
    }
  }

  // смена состояния задачи
  Future<void> _onToggleNote(
    ToggleNote event,
    Emitter<AddNoteState> emit,
  ) async {
    try {
      final note = _notes.firstWhere((note) => note.id == event.noteId);
      note.isCompleted = !note.isCompleted;

      await _firestoreService.updateNote(note);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      log('$e');
      emit(AddNoteFailure('Failed while toggle note'));
    }
  }

  // удаление задачи
  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<AddNoteState> emit,
  ) async {
    try {
      await _firestoreService.deleteNote(event.noteId);

      _notes.removeWhere((note) => note.id == event.noteId);
      emit(AddNoteSuccess(notes: List.from(_notes)));
    } catch (e) {
      log('$e');
      emit(AddNoteFailure('Failed while deleting note'));
    }
  }
}
