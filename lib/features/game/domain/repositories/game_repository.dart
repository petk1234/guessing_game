import '../models/pokemon_model.dart';

abstract class GameRepository {
  Future<List<PokemonModel>> getRandomPokemon(int count);
  Future<PokemonModel> getPokemonById(int id);
  Future<void> saveGameResult({
    required String userId,
    required int score,
    required int streak,
  });
  Future<Map<String, dynamic>> getUserStats(String userId);
} 