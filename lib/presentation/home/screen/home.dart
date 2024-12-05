import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notion_test/configs/assets/app_vectors.dart';
import 'package:notion_test/presentation/add_note/bloc/add_note_bloc.dart';
import 'package:notion_test/presentation/add_note/screen/add_note.dart';
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
          IconButton(
            onPressed: () {},
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
      body: BlocBuilder<AddNoteBloc, AddNoteState>(
        builder: (context, state) {
          if (state is AddNoteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AddNoteSuccess) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final notes = state.notes[index];
                return NoteItem(
                  title: notes.title,
                  description: notes.description,
                  dateTime: notes.date.toString(),
                  isCompleted: notes.isCompleted,
                  onToggleNote: () {
                    context.read<AddNoteBloc>().add(
                          ToggleNote(notId: notes.id),
                        );
                  },
                );
              },
            );
          } else if (state is AddNoteFailure) {
            return Text(state.errorText);
          } else {
            return const Center(child: Text('Zero notes yet'));
          }
        },
      ),
    );
  }
}
