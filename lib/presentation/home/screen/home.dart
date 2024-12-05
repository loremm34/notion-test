import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notion_test/configs/assets/app_vectors.dart';
import 'package:notion_test/presentation/add_note/bloc/add_note_bloc.dart';
import 'package:notion_test/presentation/add_note/screen/add_note.dart';
import 'package:notion_test/presentation/home/bloc/filter_sort_bloc.dart';
import 'package:notion_test/presentation/home/widgets/note_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AddNoteBloc>().add(LoadNotes());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notion'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              final filterSortBloc = context.read<FilterSortBloc>();
              if (value == 'completed') {
                filterSortBloc.add(FilterNotesEvent(isFiltered: true));
              } else if (value == 'not_completed') {
                filterSortBloc.add(FilterNotesEvent(isFiltered: false));
              } else if (value == 'all') {
                filterSortBloc.add(FilterNotesEvent(isFiltered: null));
              } else if (value == 'ascending') {
                filterSortBloc.add(SortNotesEvent(isAscending: true));
              } else if (value == 'descending') {
                filterSortBloc.add(SortNotesEvent(isAscending: false));
              }
              context.read<FilterSortBloc>().add(
                    UpdateNotesEvent(
                      notes: context.read<AddNoteBloc>().state is AddNoteSuccess
                          ? (context.read<AddNoteBloc>().state
                                  as AddNoteSuccess)
                              .notes
                          : [],
                    ),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Notes'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed'),
              ),
              const PopupMenuItem(
                value: 'not_completed',
                child: Text('Not completed'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'ascending',
                child: Text('Sort by date ↑'),
              ),
              const PopupMenuItem(
                value: 'descending',
                child: Text('Sort by date ↓'),
              ),
            ],
            icon: SvgPicture.asset(AppVectors.filterIcon),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 252, 241, 238),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<AddNoteBloc, AddNoteState>(
        listener: (context, addNoteState) {
          if (addNoteState is AddNoteSuccess) {
            context
                .read<FilterSortBloc>()
                .add(UpdateNotesEvent(notes: addNoteState.notes));
          }
        },
        builder: (context, addNoteState) {
          if (addNoteState is AddNoteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (addNoteState is AddNoteSuccess) {
            return BlocBuilder<FilterSortBloc, FilterSortState>(
              builder: (context, filterSortState) {
                final notes = filterSortState.notes;

                if (notes.isEmpty) {
                  return const Center(child: Text('Zero notes yet'));
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteItem(
                      title: note.title,
                      description: note.description,
                      dateTime: note.date.toString(),
                      isCompleted: note.isCompleted,
                      onToggleNote: () {
                        context.read<AddNoteBloc>().add(
                              ToggleNote(noteId: note.id),
                            );
                      },
                      enterNote: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddNoteScreen(
                                note: note,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          } else if (addNoteState is AddNoteFailure) {
            return Center(child: Text(addNoteState.errorText));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
