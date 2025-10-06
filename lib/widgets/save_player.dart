import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class SavePlayerButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nicknameController;
  final TextEditingController fullNameController;
  final TextEditingController contactNumberController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController remarksController;
  final RangeValues skillLevelRange;
  final String? text;
  final bool isLoading;

  const SavePlayerButton({
    super.key,
    required this.formKey,
    required this.nicknameController,
    required this.fullNameController,
    required this.contactNumberController,
    required this.emailController,
    required this.addressController,
    required this.remarksController,
    required this.skillLevelRange,
    this.text,
    this.isLoading = false,
  });

  void _savePlayer(BuildContext context) {
    print('Save button pressed!'); // Debug print
    
    if (formKey.currentState!.validate()) {
      print('Form validation passed!'); // Debug print
      
      
      final player = Player(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nickname: nicknameController.text.trim(),
        fullName: fullNameController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
        remarks: remarksController.text.trim(),
        skillLevelMin: skillLevelRange.start,
        skillLevelMax: skillLevelRange.end,
        createdAt: DateTime.now(),
      );

      print('Created player: ${player.nickname}'); // Debug print

      
      PlayerService().addPlayer(player);
      
      print('Player added to service'); // Debug print
      
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${player.nickname} added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      print('Navigating back...'); // Debug print
      
      Navigator.pop(context, true);
    } else {
      print('Form validation failed!'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _savePlayer(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text ?? 'Add Player',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
