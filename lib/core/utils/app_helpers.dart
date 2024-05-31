import 'package:flutter/material.dart';

class AppHelpers {
  static getSpacerHeight(double step) {
    return SizedBox(height: 10 * step);
  }

  static getSpacerWidth(double step) {
    return SizedBox(width: 10 * step);
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
