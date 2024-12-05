import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notion_test/data/entities/note_entity.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  bool isCompleted;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      description: description,
      date: date,
      isCompleted: isCompleted,
    );
  }

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        date: entity.date,
        isCompleted: entity.isCompleted);
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted
    };
  }

  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc['id'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: DateTime.parse(data['date']),
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}
