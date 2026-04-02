import 'dart:ui';

class FallingEmoji {
  FallingEmoji({
    required this.symbol,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotationSpeed,
    this.rotation = 0,
  });

  final String symbol;
  double x;
  double y;
  double speed;
  double size;
  double rotation;
  double rotationSpeed;

  Rect get bounds => Rect.fromLTWH(x, y, size, size);
}
