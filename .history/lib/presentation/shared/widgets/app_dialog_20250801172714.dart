// lib/presentation/shared/widgets/app_dialog.dart
// Reusable dialog widget following the project's design patterns.

import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.width,
    this.height,
  });

  final Widget title;
  final Widget content;
  final List<Widget>? actions;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SizedBox(
        width: width ?? 400,
        height: height,
        child: content,
      ),
      actions: actions,
    );
  }
}
