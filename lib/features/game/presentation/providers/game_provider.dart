import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/features/auth/domain/models/user_model.dart';
import 'package:pokemon_guessing_game/features/auth/domain/repositories/auth_repository.dart';
import '../../domain/models/pokemon_model.dart';
import '../../domain/repositories/game_repository.dart';

class GameProvider with ChangeNotifier {
  final GameRepository _gameRepository;
  final AuthRepository _authRepository;
  List<PokemonModel>? _currentOptions;
  PokemonModel? _correctPokemon;
  bool _isLoading = false;
  String? _error;
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 0;
  Timer? _timer;
  bool _showPokemonDetails = false;
  String? _userId;
  bool _isCorrectOption = false;
  List<UserModel> leaderBoardUsers = [];

  GameProvider(this._gameRepository, this._authRepository) {
    _authRepository.currentUserStream.listen((user) {
      if (user != null) {
        _userId = user.id;
      }
    });
  }

  List<PokemonModel>? get currentOptions => _currentOptions;

  PokemonModel? get correctPokemon => _correctPokemon;

  bool get isLoading => _isLoading;

  String? get error => _error;

  int get score => _score;

  int get streak => _streak;

  int get timeLeft => _timeLeft;

  bool get showPokemonDetails => _showPokemonDetails;

  bool get isCorrectOption => _isCorrectOption;

  Future<void> startNewRound() async {
    _isLoading = true;
    _error = null;
    _showPokemonDetails = false;
    if (!_isCorrectOption) {
      _streak = 0;
      _score = 0;
    }
    notifyListeners();

    try {
      final currentOptions = await _gameRepository.getRandomPokemon(4);
      _correctPokemon = currentOptions.first;
      currentOptions.shuffle();
      _currentOptions = currentOptions;
      _startTimer();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeGuess(PokemonModel selectedPokemon) async {
    final isCorrect = selectedPokemon.id == _correctPokemon!.id;
    if (isCorrect) {
      _onSuccessfulChoice();
    } else {
      _onIncorrectChoice();
    }
    notifyListeners();
  }

  Future<void> fetchLeaderBoard() async {
    try {
      _isLoading = true;
      notifyListeners();
      leaderBoardUsers = await _authRepository.getTopUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onSuccessfulChoice() {
    _score += 10;
    _streak++;
    _showPokemonDetails = true;
    _isCorrectOption = true;
    _timer?.cancel();
  }

  void _onIncorrectChoice() async {
    _endRound();
  }

  void _endRound() async {
    _timer?.cancel();
    _showPokemonDetails = true;
    _isCorrectOption = false;
    if (_correctPokemon != null && _userId != null) {
      await _gameRepository.saveGameResult(
        userId: _userId!,
        score: _score,
        streak: _streak,
      );
      await _authRepository.updateUserScore(_score);
    }
  }

  void _startTimer() {
    _timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _endRound();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
