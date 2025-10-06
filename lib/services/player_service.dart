import '../models/player.dart';

class PlayerService {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final List<Player> _players = [];

  // Get all players
  List<Player> getAllPlayers() {
    return List.unmodifiable(_players);
  }

  // Search players by nickname or full name
  List<Player> searchPlayers(String query) {
    if (query.isEmpty) return getAllPlayers();
    
    final lowercaseQuery = query.toLowerCase();
    return _players
        .where((player) => 
            player.nickname.toLowerCase().contains(lowercaseQuery) ||
            player.fullName.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Add a new player
  void addPlayer(Player player) {
    _players.add(player);
  }

  // Update existing player
  void updatePlayer(Player updatedPlayer) {
    final index = _players.indexWhere((player) => player.id == updatedPlayer.id);
    if (index != -1) {
      _players[index] = updatedPlayer;
    }
  }

  // Delete player
  void deletePlayer(String playerId) {
    _players.removeWhere((player) => player.id == playerId);
  }

  // Get player by ID
  Player? getPlayerById(String id) {
    try {
      return _players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get players count
  int getPlayersCount() {
    return _players.length;
  }

  // Clear all players (for testing)
  void clearAll() {
    _players.clear();
  }
}