part of 'filter_sort_bloc.dart';

@immutable
sealed class FilterSortEvent {}

class FilterNotesEvent extends FilterSortEvent {
  final bool? isFiltered;

  FilterNotesEvent({required this.isFiltered});
}

class SortNotesEvent extends FilterSortEvent {
  final bool? isAscending;

  SortNotesEvent({required this.isAscending});
}

class UpdateNotesEvent extends FilterSortEvent {
  final List<NoteModel> notes;

  UpdateNotesEvent({required this.notes});
}
