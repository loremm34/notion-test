import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isCompleted,
    required this.onToggleNote,
    required this.enterNote,
  });

  final String title;
  final String description;
  final String dateTime;
  final bool isCompleted;
  final VoidCallback onToggleNote;
  final VoidCallback enterNote;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 252, 241, 238),
        ),
        child: InkWell(
          onTap: enterNote,
          child: SizedBox(
            child: Padding(
              padding: width > 600
                  ? const EdgeInsets.all(2.0)
                  : const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: onToggleNote,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              dateTime,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
