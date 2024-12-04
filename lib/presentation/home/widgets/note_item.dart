import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  final String title;
  final String description;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 252, 241, 238),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(description),
                Row(
                  children: [
                    const Spacer(),
                    Text(dateTime),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
