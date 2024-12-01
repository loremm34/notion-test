import 'package:flutter/material.dart';

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
          backgroundColor: Colors.white,
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
        ),
      ),
    );
  }
}
