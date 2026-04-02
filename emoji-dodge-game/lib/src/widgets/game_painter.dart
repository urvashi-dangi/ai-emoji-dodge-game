import 'package:flutter/material.dart';

import '../models/falling_emoji.dart';

class GamePainter extends CustomPainter {
  GamePainter({
    required this.emojis,
    required this.playerCenterX,
    required this.playerSize,
    required this.playerY,
    required this.collisionCenter,
    required this.collisionEmoji,
    required this.collisionProgress,
  });

  final List<FallingEmoji> emojis;
  final double playerCenterX;
  final double playerSize;
  final double playerY;
  final Offset? collisionCenter;
  final String? collisionEmoji;
  final double collisionProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[
          Color(0xFFFFF4D8),
          Color(0xFFFFD6A5),
          Color(0xFFFFC2C7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final glowPaint = Paint()..color = const Color(0x66FFFFFF);
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.16),
      size.width * 0.18,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.28),
      size.width * 0.14,
      glowPaint,
    );

    for (final emoji in emojis) {
      canvas.save();
      canvas.translate(emoji.x + (emoji.size / 2), emoji.y + (emoji.size / 2));
      canvas.rotate(emoji.rotation);
      final textPainter = TextPainter(
        text: TextSpan(
          text: emoji.symbol,
          style: TextStyle(fontSize: emoji.size),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    final playerTextPainter = TextPainter(
      text: TextSpan(
        text: '😎',
        style: TextStyle(fontSize: playerSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    playerTextPainter.paint(
      canvas,
      Offset(
        playerCenterX - (playerTextPainter.width / 2),
        playerY - (playerTextPainter.height / 2),
      ),
    );

    if (collisionCenter != null && collisionProgress > 0) {
      final center = collisionCenter!;
      final burstRadius = playerSize * (0.5 + (collisionProgress * 1.8));
      final burstPaint = Paint()
        ..color = const Color(0xFFFF6B6B).withValues(
          alpha: (1 - collisionProgress) * 0.45,
        )
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, burstRadius, burstPaint);

      final ringPaint = Paint()
        ..color = const Color(0xFFFFC43D).withValues(
          alpha: (1 - collisionProgress) * 0.95,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawCircle(center, burstRadius * 0.82, ringPaint);

      final hitTextPainter = TextPainter(
        text: TextSpan(
          text: collisionEmoji ?? '💥',
          style: TextStyle(fontSize: playerSize * (1 + collisionProgress)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      hitTextPainter.paint(
        canvas,
        Offset(
          center.dx - (hitTextPainter.width / 2),
          center.dy - (hitTextPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    // Emoji positions are mutated in place during the game loop, so the list
    // reference often stays the same even though the frame contents changed.
    return true;
  }
}
