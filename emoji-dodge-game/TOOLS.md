# Tools

## Core Stack

- Flutter
- Dart
- Material 3
- `Ticker` for the frame loop
- `CustomPainter` for rendering

## Game Systems

- `StatefulWidget` for game state
- `Navigator` for home-to-game routing
- `Listener` for pointer movement
- Bounding-box collision detection

## Development Commands

Run the app:

```bash
flutter run
```

Run on Android emulator:

```bash
flutter run -d emulator-5554
```

Analyze:

```bash
flutter analyze
```

Test:

```bash
flutter test
```

Build release APK:

```bash
flutter build apk --release
```

## Important Files

- `lib/main.dart`: entry point
- `lib/emoji_dodge_app.dart`: app shell and score persistence
- `lib/src/screens/home_screen.dart`: home UI and start navigation
- `lib/src/screens/game_screen.dart`: gameplay loop and collision logic
- `lib/src/widgets/game_painter.dart`: rendering
- `lib/src/models/falling_emoji.dart`: emoji model
