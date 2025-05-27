class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final int highScore;
  final int currentStreak;
  final int bestStreak;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.highScore = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'highScore': highScore,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      highScore: map['highScore'] as int? ?? 0,
      currentStreak: map['currentStreak'] as int? ?? 0,
      bestStreak: map['bestStreak'] as int? ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    int? highScore,
    int? currentStreak,
    int? bestStreak,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      highScore: highScore ?? this.highScore,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }
} 