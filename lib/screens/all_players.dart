import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import '../widgets/player_widget.dart';
import '../widgets/add_player.dart';
import 'add_new_player.dart';
import 'edit_screen.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({super.key});

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final PlayerService _playerService = PlayerService();
  final TextEditingController _searchController = TextEditingController();
  List<Player> _filteredPlayers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshPlayerList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshPlayerList() {
    setState(() {
      _filteredPlayers = _searchQuery.isEmpty 
          ? _playerService.getAllPlayers()
          : _playerService.searchPlayers(_searchQuery);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _refreshPlayerList();
    });
  }

  void _navigateToAddPlayer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewPlayerScreen()),
    );
    
    // Refresh the list when returning from add player screen
    if (result == true) {
      _refreshPlayerList();
    }
  }

  void _navigateToEditPlayer(Player player) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPlayerScreen(player: player)),
    );
    
    // Refresh the list when returning from edit player screen
    if (result == true) {
      _refreshPlayerList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badminton Players'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search players...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: _filteredPlayers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = _filteredPlayers[index];
                return PlayerWidget(
                  player: player,
                  onRefresh: _refreshPlayerList,
                  onEdit: () => _navigateToEditPlayer(player),
                );
              },
            ),
      floatingActionButton: AddPlayerButton(
        onPressed: _navigateToAddPlayer,
        isFloating: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No players yet' : 'No players found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty 
                ? 'Add your first player to get started!'
                : 'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
