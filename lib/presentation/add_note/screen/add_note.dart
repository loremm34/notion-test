import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notion_test/data/models/note_model.dart';
import 'package:notion_test/presentation/add_note/bloc/add_note_bloc.dart';
import 'package:notion_test/services/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});

  final NoteModel? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedDateTime;
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
    _selectedDateTime = widget.note != null
        ? _formatDateTime(widget.note!.date)
        : _formatDateTime(DateTime.now());
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

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? false) {
      final dateTime = DateFormat('MM dd yyyy HH:mm').parse(_selectedDateTime);
      final note = NoteModel(
        id: widget.note?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: dateTime,
      );

      context.read<AddNoteBloc>().add(
            widget.note == null ? AddNote(note: note) : UpdateNote(note: note),
          );

      Navigator.pop(context);
    }
  }

  void _deleteNote() {
    if (widget.note != null) {
      context.read<AddNoteBloc>().add(DeleteNote(noteId: widget.note!.id));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.note == null ? 'Add New Note' : 'Edit Note'),
        centerTitle: true,
        actions: widget.note != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteNote,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  'Pick Date and Time: $_selectedDateTime',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter note title',
                  hintStyle: TextStyle(fontSize: 18),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter note description',
                  hintStyle: TextStyle(fontSize: 15),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveNote,
                      child:
                          Text(widget.note == null ? 'Add Note' : 'Save Note'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
