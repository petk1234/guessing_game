import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/features/game/data/repositories/game_repository_impl.dart';
import 'package:pokemon_guessing_game/features/routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepositoryImpl>(
          create: (_) => AuthRepositoryImpl(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pokemon Guessing Game',
        theme: AppTheme.lightTheme,
        initialRoute: '/login',
        routes: routes,
      ),
    );
  }
} 