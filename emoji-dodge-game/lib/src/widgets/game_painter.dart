import 'package:flutter/material.dart';

import '../models/falling_emoji.dart';

class GamePainter extends CustomPainter {
  GamePainter({
    required this.emojis,
    required this.playerCenterX,
    required this.playerSize,
    required this.playerY,
  });

  final List<FallingEmoji> emojis;
  final double playerCenterX;
  final double playerSize;
  final double playerY;

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
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return oldDelegate.emojis != emojis ||
        oldDelegate.playerCenterX != playerCenterX ||
        oldDelegate.playerY != playerY ||
        oldDelegate.playerSize != playerSize;
  }
}
