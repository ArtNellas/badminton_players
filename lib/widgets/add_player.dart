import 'package:flutter/material.dart';

class AddPlayerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final IconData? icon;
  final bool showIcon;
  final bool isFloating;

  const AddPlayerButton({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.showIcon = true,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFloating) {
      // Floating Action Button variant
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.add),
        label: Text(text ?? 'Add Player'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: showIcon ? Icon(icon ?? Icons.add) : const SizedBox.shrink(),
        label: Text(text ?? 'Add Player'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
