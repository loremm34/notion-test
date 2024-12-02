import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 241, 238),
        ),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'),
                Text("data"),
                Row(
                  children: [
                    Spacer(),
                    Text('12.20.35'),
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
