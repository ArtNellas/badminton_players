import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class UpdatePlayerButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Player originalPlayer;
  final TextEditingController nicknameController;
  final TextEditingController fullNameController;
  final TextEditingController contactNumberController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController remarksController;
  final RangeValues skillLevelRange;

  const UpdatePlayerButton({
    super.key,
    required this.formKey,
    required this.originalPlayer,
    required this.nicknameController,
    required this.fullNameController,
    required this.contactNumberController,
    required this.emailController,
    required this.addressController,
    required this.remarksController,
    required this.skillLevelRange,
  });

  void _updatePlayer(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Create updated player with same ID and creation date
      final updatedPlayer = Player(
        id: originalPlayer.id,
        nickname: nicknameController.text.trim(),
        fullName: fullNameController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        remarks: remarksController.text.trim(),
        skillLevelMin: skillLevelRange.start,
        skillLevelMax: skillLevelRange.end,
        createdAt: originalPlayer.createdAt, // Keep original creation date
      );

      // Update player in service
      PlayerService().updatePlayer(updatedPlayer);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Player updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to previous screen
      Navigator.of(context).pop(true); // Return true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _updatePlayer(context),
        icon: const Icon(Icons.save),
        label: const Text(
          'Update Player',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}