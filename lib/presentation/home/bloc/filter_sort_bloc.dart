import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notion_test/data/models/note_model.dart';

part 'filter_sort_event.dart';
part 'filter_sort_state.dart';

class FilterSortBloc extends Bloc<FilterSortEvent, FilterSortState> {
  FilterSortBloc() : super(FilterSortInitial()) {
    on<SortNotesEvent>(_onSortNotes);
    on<FilterNotesEvent>(_onFilterNotes);
    on<UpdateNotesEvent>(_onUpdateNotes);
  }

  void _onSortNotes(SortNotesEvent event, Emitter<FilterSortState> emit) {
    final sortedNotes = _applySort(state.notes, isAscending: event.isAscending);
    emit(
      FilterSortState(
        notes: sortedNotes,
        isFiltered: state.isFiltered,
        isAscending: event.isAscending,
      ),
    );
  }

  void _onFilterNotes(FilterNotesEvent event, Emitter<FilterSortState> emit) {
    final filteredNotes = _applyFilter(
      state.notes,
      isFiltered: event.isFiltered,
    );
    emit(
      FilterSortState(
        notes: _applySort(filteredNotes, isAscending: state.isAscending),
        isFiltered: event.isFiltered,
        isAscending: state.isAscending,
      ),
    );
  }

  void _onUpdateNotes(UpdateNotesEvent event, Emitter<FilterSortState> emit) {
    final filteredNotes = _applyFilter(
      event.notes,
      isFiltered: state.isFiltered,
    );
    emit(
      FilterSortState(
        notes: _applySort(filteredNotes, isAscending: state.isAscending),
        isFiltered: state.isFiltered,
        isAscending: state.isAscending,
      ),
    );
  }

  List<NoteModel> _applySort(List<NoteModel> notes,
      {required bool? isAscending}) {
    if (isAscending == null) return notes;
    return List.from(notes)
      ..sort(
        (a, b) =>
            isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
      );
  }

  List<NoteModel> _applyFilter(List<NoteModel> notes,
      {required bool? isFiltered}) {
    if (isFiltered == null) return notes;

    return notes.where((note) => note.isCompleted == isFiltered).toList();
  }
}
