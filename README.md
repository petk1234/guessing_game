# Pokemon Guessing Game

A Flutter application that tests your Pokemon knowledge! Guess the Pokemon from a blurred image and compete with other players.

## Features

- 🔐 User authentication with Firebase
- 🎮 Interactive Pokemon guessing game
- 🎯 Score tracking and streaks
- 📊 Detailed Pokemon stats and information
- ⏱️ Time-based rounds
- 🏆 High score tracking

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Firebase account
- Android Studio / VS Code with Flutter extensions

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/pokemon-guessing-game.git
cd pokemon-guessing-game
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Add your Android/iOS app to the Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. Run the app:
```bash
flutter run
```

## Project Structure

The project follows Clean Architecture principles:

```
lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── game/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Dependencies

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase Authentication
- `cloud_firestore`: Cloud Firestore database
- `provider`: State management
- `http`: HTTP requests
- `cached_network_image`: Image caching
- `flutter_blur`: Image blurring effects
- `shared_preferences`: Local storage
- `intl`: Internationalization

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [PokeAPI](https://pokeapi.co/) for providing Pokemon data
- [Flutter](https://flutter.dev/) for the amazing framework
- [Firebase](https://firebase.google.com/) for backend services 