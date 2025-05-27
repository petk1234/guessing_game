import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get currentUserStream;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String displayName);
  Future<void> signOut();
  Future<void> updateUserProfile(String displayName);
  Future<void> updateUserScore(int score);
  Future<List<UserModel>> getTopUsers();
} 