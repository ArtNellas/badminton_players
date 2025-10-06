import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final VoidCallback? onRefresh;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const PlayerWidget({
    super.key,
    required this.player,
    this.onRefresh,
    this.onEdit,
    this.onTap,
  });

  String _getSkillLevelText(double value) {
    final skillLevels = [
      'Beginner', 'Beginner', 'Beginner',
      'Intermediate', 'Intermediate', 'Intermediate',
      'Level G', 'Level G', 'Level G',
      'Level F', 'Level F', 'Level F',
      'Level E', 'Level E', 'Level E',
      'Level D', 'Level D', 'Level D',
      'Open Player', 'Open Player', 'Open Player'
    ];
    
    final skillSubLevels = [
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong',
      'Weak', 'Mid', 'Strong'
    ];
    
    int index = value.round().clamp(0, skillLevels.length - 1);
    return '${skillLevels[index]} (${skillSubLevels[index]})';
  }

  String _getSkillRangeText() {
    if (player.skillLevelMin == player.skillLevelMax) {
      return _getSkillLevelText(player.skillLevelMin);
    }
    return '${_getSkillLevelText(player.skillLevelMin)} → ${_getSkillLevelText(player.skillLevelMax)}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(player.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Player'),
              content: Text('Are you sure you want to delete ${player.nickname}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        PlayerService().deletePlayer(player.id);
        if (onRefresh != null) {
          onRefresh!();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${player.nickname} deleted'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                PlayerService().addPlayer(player);
                if (onRefresh != null) {
                  onRefresh!();
                }
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              player.nickname.isNotEmpty ? player.nickname[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            player.nickname,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(player.fullName),
              const SizedBox(height: 4),
              Text(
                'Skill: ${_getSkillRangeText()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onEdit ?? onTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Editing ${player.nickname}')),
            );
          },
        ),
      ),
    );
  }
}
