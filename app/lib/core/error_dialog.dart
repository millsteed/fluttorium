import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({required this.error, super.key});

  final String error;

  static void show(BuildContext context, String error) {
    showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(error: error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(error),
      actions: [
        _buildCloseButton(context),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return TextButton(
      onPressed: Navigator.of(context).pop,
      child: const Text('Close'),
    );
  }
}
