import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/features/auth/domain/models/user_model.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if(!mounted) return;
      if (context.read<GameProvider>().leaderBoardUsers.isEmpty) {
        context.read<GameProvider>().fetchLeaderBoard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
        ),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Top Players',
                style: theme.textTheme.headlineMedium,
              )),
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (gameProvider.leaderBoardUsers.isEmpty ||
                  gameProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (gameProvider.error != null) {
                return Center(
                  child: Text(
                    'Error: ${gameProvider.error}',
                    style:
                        theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
                  ),
                );
              }

              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: RefreshIndicator(
                          onRefresh: gameProvider.fetchLeaderBoard,
                          child: ListView.builder(
                            itemCount: gameProvider.leaderBoardUsers.length,
                            itemBuilder: (context, index) {
                              final user = gameProvider.leaderBoardUsers[index];
                              return _buildLeaderboardItem(
                                  index: index, user: user);
                            },
                          ),
                        ))
                      ],
                    ),
                  ));
            },
          ),
        ]));
  }

  Widget _buildLeaderboardItem({required int index, required UserModel user}) {
    final theme = Theme.of(context);
    final leadersColors = [
      Colors.yellow.withOpacity(0.2),
      Colors.grey.withOpacity(0.2),
      Colors.brown.withOpacity(0.2),
    ];

    return Container(
      key: ValueKey(user.id),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: index < 3 ? leadersColors[index] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '#${index + 1}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              user.displayName ?? "",
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Text(
            'Score: ${user.highScore}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
