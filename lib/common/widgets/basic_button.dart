import 'package:flutter/material.dart';

// Реюз кнопки
class BasicButton extends StatelessWidget {
  const BasicButton({super.key, required this.buttonText, required this.onTap});

  final String buttonText;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 252, 241, 238),
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
        ),
      ),
    );
  }
}
