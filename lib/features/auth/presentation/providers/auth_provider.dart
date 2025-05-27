import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authRepository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.createUserWithEmailAndPassword(
        email,
        password,
        displayName
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _user = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.updateUserProfile(displayName);
      _user = _user?.copyWith(displayName: displayName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateScore(int score) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.updateUserScore(score);
      if (_user != null) {
        _user = _user!.copyWith(
          highScore: score > _user!.highScore ? score : _user!.highScore,
          currentStreak: _user!.currentStreak + 1,
          bestStreak: _user!.currentStreak + 1 > _user!.bestStreak
              ? _user!.currentStreak + 1
              : _user!.bestStreak,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 