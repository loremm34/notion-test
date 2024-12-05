part of 'filter_sort_bloc.dart';

class FilterSortState {
  final List<NoteModel> notes;
  final bool? isFiltered;
  final bool? isAscending;

  FilterSortState(
      {required this.notes,
      required this.isFiltered,
      required this.isAscending});

  FilterSortState.initial()
      : notes = const [],
        isFiltered = null,
        isAscending = true;
}

class FilterSortInitial extends FilterSortState {
  FilterSortInitial() : super.initial();
}
