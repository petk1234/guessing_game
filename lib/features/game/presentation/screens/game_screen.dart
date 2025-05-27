import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/features/auth/presentation/providers/auth_provider.dart';
import 'package:pokemon_guessing_game/features/game/presentation/widgets/pokemon_stats.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../../domain/models/pokemon_model.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.signOut();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error!)),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokemon Guessing Game'),
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _handleLogout(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.leaderboard),
                onPressed: () {
                  Navigator.pushNamed(context, '/leaderboard');
                },
              ),
            ],
          ),
          body: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              final GAME_STATS = [
                'Score: ${gameProvider.score}',
                'Streak: ${gameProvider.streak}',
                'Time Left: ${gameProvider.timeLeft}s',
              ];

              if (gameProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (gameProvider.error != null) {
                _buildErrorState(gameProvider);
              }

              if (gameProvider.currentOptions == null) {
                return Center(
                  child: ElevatedButton(
                    onPressed: gameProvider.startNewRound,
                    child: const Text('Start Round'),
                  ),
                );
              }

              return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: GAME_STATS
                              .map((stat) => Text(stat,
                                  style:
                                      Theme.of(context).textTheme.titleLarge))
                              .toList(),
                        ),
                      ),
                      _buildPokemonImage(
                        showPokemonDetails: gameProvider.showPokemonDetails,
                        imageUrl: gameProvider.correctPokemon?.imageUrl ?? '',
                        imgHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height *
                                          0.39),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ...gameProvider.showPokemonDetails &&
                                            gameProvider.correctPokemon != null
                                        ? [
                                            _buildStats(
                                                gameProvider.correctPokemon!,
                                                gameProvider),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            _buildAction(
                                                isCorrectOption: gameProvider
                                                    .isCorrectOption,
                                                startNewRound:
                                                    gameProvider.startNewRound)
                                          ]
                                        : [
                                            _buildOptions(
                                                pokemons: gameProvider
                                                    .currentOptions!,
                                                makeGuess:
                                                    gameProvider.makeGuess)
                                          ],
                                  ]))),
                    ],
                  ));
            },
          ),
        ));
  }

  Widget _buildErrorState(GameProvider gameProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${gameProvider.error}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: gameProvider.startNewRound,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonImage(
      {required bool showPokemonDetails,
      required String imageUrl,
      required double imgHeight}) {
    final blurEffect = showPokemonDetails ? 0.0 : 8.0;
    return Container(
        height: imgHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Center(
          child: ClipRect(
            child: ImageFiltered(
              imageFilter:
                  ImageFilter.blur(sigmaX: blurEffect, sigmaY: blurEffect),
              child: Image.network(
                imageUrl,
                errorBuilder: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }

  Widget _buildOptions(
      {required List<PokemonModel> pokemons,
      required Future<void> Function(PokemonModel) makeGuess}) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0, right: 16.0, left: 16.0),
      child: Column(
        children: pokemons
            .map(
              (pokemon) => Padding(
                key: ValueKey(pokemon.id),
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => makeGuess(pokemon),
                    child: Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStats(PokemonModel pokemon, GameProvider gameProvider) {
    return Column(
      children: [
        gameProvider.isCorrectOption
            ? const Text(
                '🥳 You caught it! 🥳',
                style: TextStyle(color: Colors.green, fontSize: 24),
              )
            : const Text(
                '❌ Ooops... It was ❌',
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
        Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: pokemon.types.map((type) {
            return Chip(
              label: Text(
                type.name.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: type.color,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        PokemonStats(pokemon: pokemon),
      ],
    );
  }

  Widget _buildAction(
      {required bool isCorrectOption,
      required Future<void> Function() startNewRound}) {
    return isCorrectOption
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
            onPressed: startNewRound,
            child: const Text('Go next', style: TextStyle(fontSize: 18)))
        : IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: startNewRound,
          );
  }
}
