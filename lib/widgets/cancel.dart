import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool showConfirmDialog;

  const CancelButton({
    super.key,
    this.onPressed,
    this.text,
    this.showConfirmDialog = false,
  });

  void _handleCancel(BuildContext context) {
    if (showConfirmDialog) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cancel'),
            content: const Text('Are you sure you want to cancel? Any unsaved changes will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  if (onPressed != null) {
                    onPressed!();
                  } else {
                    Navigator.pop(context); // Default behavior
                  }
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    } else {
      if (onPressed != null) {
        onPressed!();
      } else {
        Navigator.pop(context); // Default behavior
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleCancel(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Text(
        text ?? 'Cancel',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}