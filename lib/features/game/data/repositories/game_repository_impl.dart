import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_guessing_game/features/auth/domain/models/user_model.dart';
import 'dart:convert';
import '../../domain/models/pokemon_model.dart';
import '../../domain/repositories/game_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_constants.dart';

class GameRepositoryImpl implements GameRepository {
  final FirebaseFirestore _firestore;
  final http.Client _client;

  GameRepositoryImpl({
    FirebaseFirestore? firestore,
    http.Client? client,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _client = client ?? http.Client();

  @override
  Future<List<PokemonModel>> getRandomPokemon(int count) async {
    try {
      final random = Random();
      final pokemonIds = <int>{};
      
      while (pokemonIds.length < count) {
        pokemonIds.add(random.nextInt(ApiConstants.maxPokemonCount) + 1);
      }
      final pokemonList = await Future.wait(
        pokemonIds.map((id) => getPokemonById(id)),
      );

      return pokemonList;
    } catch (e) {
      throw const ServerFailure('Failed to fetch random Pokemon');
    }
  }

  @override
  Future<PokemonModel> getPokemonById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        return PokemonModel.fromJson(json.decode(response.body));
      } else {
        throw const ServerFailure('Failed to fetch Pokemon');
      }
    } catch (e) {
      throw const ServerFailure('Failed to fetch Pokemon');
    }
  }

  @override
  Future<void> saveGameResult({
    required String userId,
    required int score,
    required int streak,
  }) async {
    try {
      print('Saving game result: $userId, $score');
      await _firestore.collection('users').doc(userId).collection('rounds_history').add({
        'timestamp': FieldValue.serverTimestamp(),
        'score': score,
        'streak': streak,
      });
      final user = await _firestore.collection('users').doc(userId).get().then((doc) => UserModel.fromMap(doc.data()!));
      if(user.highScore < score) {
        await _firestore.collection('users').doc(userId).update({
          'highScore': score,
          'bestStreak': streak,
        });
      }
    } catch (e) {
      throw const ServerFailure('Failed to save game result');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('game_history')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      int totalGames = snapshot.docs.length;
      int correctGuesses = snapshot.docs
          .where((doc) => doc.data()['isCorrect'] == true)
          .length;
      int totalScore = snapshot.docs.fold(
          0, (sum, doc) => sum + (doc.data()['score'] as int));

      return {
        'totalGames': totalGames,
        'correctGuesses': correctGuesses,
        'accuracy': totalGames > 0 ? correctGuesses / totalGames : 0,
        'totalScore': totalScore,
        'averageScore': totalGames > 0 ? totalScore / totalGames : 0,
      };
    } catch (e) {
      throw const ServerFailure('Failed to fetch user stats');
    }
  }
} 