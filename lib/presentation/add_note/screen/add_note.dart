import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notion_test/common/widgets/basic_button.dart';
import 'package:notion_test/data/models/note_model.dart';
import 'package:notion_test/presentation/add_note/bloc/add_note_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedDateTime = '';

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _formatDateTime(DateTime.now());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM dd yyyy HH:mm').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      await _selectTime(context, pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime != null) {
      final DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        _selectedDateTime = _formatDateTime(combinedDateTime);
      });
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Pick Date and Time: $_selectedDateTime',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  filled: false,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: 'Books to read in 2023 📚',
                  hintStyle: TextStyle(fontSize: 25),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                maxLength: 80,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  filled: false,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText:
                      'I have a new year resolution to read one book in a month,',
                  hintStyle: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              BasicButton(
                buttonText: 'Add Note',
                onTap: () {
                  final dateTime =
                      DateFormat('MM dd yyyy HH:mm').parse(_selectedDateTime);
                  final note = NoteModel(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    date: dateTime,
                  );
                  context.read<AddNoteBloc>().add(AddNote(note: note));

                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
