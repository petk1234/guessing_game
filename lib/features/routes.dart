import 'package:flutter/cupertino.dart';
import 'package:pokemon_guessing_game/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pokemon_guessing_game/features/auth/presentation/screens/login_screen.dart';
import 'package:pokemon_guessing_game/features/auth/presentation/screens/register_screen.dart';
import 'package:pokemon_guessing_game/features/game/data/repositories/game_repository_impl.dart';
import 'package:pokemon_guessing_game/features/game/presentation/providers/game_provider.dart';
import 'package:pokemon_guessing_game/features/game/presentation/screens/game_screen.dart';
import 'package:pokemon_guessing_game/features/game/presentation/screens/leaderboard_screen.dart';
import 'package:provider/provider.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/game': (context) => MultiProvider(providers: [
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(
            GameRepositoryImpl(),
            context.read<AuthRepositoryImpl>(),
          ),
        ),
      ], child: const GameScreen()),
  '/leaderboard': (context) => MultiProvider(providers: [
    // ChangeNotifierProvider<GameProvider>(
    //   create: (context) {
    //     print('Fetching leaderboard users');
    //     final provider = GameProvider
    //   (
    //     context.read<GameRepositoryImpl>(),
    //     context.read<AuthRepositoryImpl>(),
    //   );
    //
    //     return provider;
    //     },
    // ),
    ChangeNotifierProvider<GameProvider>(
      create: (context) => GameProvider(
        GameRepositoryImpl(),
        context.read<AuthRepositoryImpl>(),
      ),
    ),
  ], child: const LeaderboardScreen()),
};
