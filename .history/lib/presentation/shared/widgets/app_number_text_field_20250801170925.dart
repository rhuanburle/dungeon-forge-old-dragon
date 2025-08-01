// lib/presentation/shared/widgets/app_number_text_field.dart
// A small reusable text field widget configured for numeric input.
// This helps to keep UI code concise and consistent.

import 'package:flutter/material.dart';

class AppNumberTextField extends StatelessWidget {
  const AppNumberTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
