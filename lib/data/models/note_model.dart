import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notion_test/data/entities/note_entity.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      description: description,
      date: date,
    );
  }

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory NoteModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc['id'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: DateTime.parse(data['date']),
    );
  }
}
