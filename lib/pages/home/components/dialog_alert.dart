import 'package:flutter/material.dart';

class DialogAlert extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget>? actions;

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DialogAlert(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  const DialogAlert({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions ??
          [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
    );
  }
}
