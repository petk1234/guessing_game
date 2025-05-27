import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rxdart/rxdart.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _currentUserStreamController = BehaviorSubject<UserModel?>();

  @override
  Stream<UserModel?> get currentUserStream => _currentUserStreamController.stream;
  StreamSink<UserModel?> get currentUserSink => _currentUserStreamController.sink;

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final currentUser = UserModel.fromMap(doc.data()!);
      _currentUserStreamController.add(currentUser);
      return currentUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw const AuthFailure('Authentication failed');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName
      );
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      _currentUserStreamController.add(user);
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw const AuthFailure('Registration failed');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentUserStreamController.add(null);
  }

  @override
  Future<void> updateUserProfile(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const AuthFailure('No user logged in');

      await user.updateDisplayName(displayName);
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'displayName': displayName});
    } catch (e) {
      throw const AuthFailure('Failed to update profile');
    }
  }

  @override
  Future<void> updateUserScore(int score) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const AuthFailure('No user logged in');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = UserModel.fromMap(userDoc.data()!);

      final newHighScore = score > userData.highScore ? score : userData.highScore;
      final newStreak = userData.currentStreak + 1;
      final newBestStreak =
          newStreak > userData.bestStreak ? newStreak : userData.bestStreak;

      await _firestore.collection('users').doc(user.uid).update({
        'highScore': newHighScore,
        'bestStreak': newBestStreak,
      });
    } catch (e) {
      throw const AuthFailure('Failed to update score');
    }
  }

  @override
  Future<List<UserModel>> getTopUsers() {
    try{
      return _firestore
          .collection('users')
          .orderBy('highScore', descending: true)
          .limit(10)
          .get()
          .then((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList());
    } catch (e) {
      throw const ServerFailure('Failed to fetch top users');
    }
  }
} 