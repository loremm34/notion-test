part of 'filter_sort_bloc.dart';

@immutable
sealed class FilterSortEvent {}

// ивент фильтрации
class FilterNotesEvent extends FilterSortEvent {
  final bool? isFiltered;

  FilterNotesEvent({required this.isFiltered});
}

// ивент сортировки
class SortNotesEvent extends FilterSortEvent {
  final bool? isAscending;

  SortNotesEvent({required this.isAscending});
}

// ивент обновления задачи
class UpdateNotesEvent extends FilterSortEvent {
  final List<NoteModel> notes;

  UpdateNotesEvent({required this.notes});
}
