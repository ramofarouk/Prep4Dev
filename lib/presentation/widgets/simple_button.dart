import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  const SimpleButton(
      {super.key,
      required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
