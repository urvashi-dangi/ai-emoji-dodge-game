# Emoji Dodge

`Emoji Dodge` is a Flutter arcade game where the player survives by avoiding falling emojis for as long as possible.

## Features

- Home screen with title, best score, and last score
- Start game navigation from the home screen
- Real-time game loop using `Ticker`
- Falling emoji obstacles with random size, speed, and type
- Survival-based scoring
- Level-based difficulty progression
- Collision animation before game over
- Pause and restart support

## Gameplay

- The player character sits near the bottom of the screen.
- Emojis start falling as soon as the game begins.
- Move the player horizontally to avoid collisions.
- Score increases over time.
- Speed and spawn pressure increase level by level.

## Project Structure

```text
lib/
  main.dart
  emoji_dodge_app.dart
  src/
    models/
      falling_emoji.dart
    screens/
      home_screen.dart
      game_screen.dart
    widgets/
      game_painter.dart
test/
  widget_test.dart
```

## Run

```bash
flutter pub get
flutter run
```

## Verify

```bash
flutter analyze
flutter test
```

## Notes

- The game is built with Flutter and Dart only.
- No external game engine is used.
- Rendering is handled with `CustomPaint`.
- Collision uses simple bounding-box checks.
