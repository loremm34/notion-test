// entity задачи
class NoteEntity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;

  NoteEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });
}
