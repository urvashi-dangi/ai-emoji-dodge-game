import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/falling_emoji.dart';
import '../widgets/game_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _emojiPool = <String>[
    '😂',
    '🔥',
    '💣',
    '👾',
    '⚡',
    '🌪️',
    '😈',
    '🍕',
    '🛸',
    '🌟',
  ];

  final math.Random _random = math.Random();
  final List<FallingEmoji> _emojis = <FallingEmoji>[];

  late final Ticker _ticker;
  Duration? _lastTick;
  double _spawnAccumulator = 0;
  double _survivalTime = 0;
  double _playerCenterX = 0;
  double _playerTargetX = 0;
  bool _isRunning = true;
  bool _isGameOver = false;
  bool _resultSent = false;
  Size _playSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  int get _score => (_survivalTime * 10).floor();

  double get _difficulty => 1 + (_survivalTime / 18);

  double get _playerSize {
    if (_playSize == Size.zero) {
      return 60;
    }
    return _playSize.width.clamp(280, 520) * 0.14;
  }

  double get _playerY {
    if (_playSize == Size.zero) {
      return 0;
    }
    return _playSize.height - (_playerSize * 0.85);
  }

  Rect get _playerBounds => Rect.fromCenter(
    center: Offset(_playerCenterX, _playerY),
    width: _playerSize * 0.8,
    height: _playerSize * 0.8,
  );

  void _onTick(Duration elapsed) {
    if (!_isRunning || !mounted) {
      _lastTick = elapsed;
      return;
    }

    final previous = _lastTick;
    _lastTick = elapsed;
    if (previous == null || _playSize == Size.zero) {
      return;
    }

    var dt =
        (elapsed - previous).inMicroseconds / Duration.microsecondsPerSecond;
    dt = dt.clamp(0, 0.05);

    // Keep score and spawn rate tied to real survival time so the game
    // feels consistent across devices with different frame timings.
    _survivalTime += dt;
    _spawnAccumulator += dt;
    final spawnInterval = math.max(0.18, 0.72 - (_difficulty * 0.05));

    final followStrength = 14 * dt;
    _playerCenterX += (_playerTargetX - _playerCenterX) *
        followStrength.clamp(0.0, 1.0);

    while (_spawnAccumulator >= spawnInterval) {
      _spawnAccumulator -= spawnInterval;
      _spawnEmoji();
    }

    for (final emoji in _emojis) {
      emoji.y += emoji.speed * dt;
      emoji.rotation += emoji.rotationSpeed * dt;
    }

    _emojis.removeWhere(
      (FallingEmoji emoji) => emoji.y > _playSize.height + emoji.size,
    );

    final playerBounds = _playerBounds;
    for (final emoji in _emojis) {
      if (emoji.bounds.overlaps(playerBounds)) {
        _triggerGameOver();
        break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _spawnEmoji() {
    final size = 28 + _random.nextDouble() * 26;
    final speed = (180 + _random.nextDouble() * 120) * _difficulty;
    final maxX = math.max(0.0, _playSize.width - size);

    // Each emoji gets its own symbol, spawn lane, and fall speed to keep
    // the pattern unpredictable as difficulty ramps up.
    _emojis.add(
      FallingEmoji(
        symbol: _emojiPool[_random.nextInt(_emojiPool.length)],
        x: maxX == 0 ? 0 : _random.nextDouble() * maxX,
        y: -size,
        size: size,
        speed: speed,
        rotationSpeed: (_random.nextDouble() - 0.5) * 1.6,
      ),
    );
  }

  void _spawnOpeningWave() {
    if (_playSize == Size.zero) {
      return;
    }

    const openingOffsets = <double>[24, -90, -210];

    for (var index = 0; index < openingOffsets.length; index++) {
      _spawnEmoji();
      _emojis.last.y = openingOffsets[index];
    }
  }

  void _updatePlayerTarget(double dx) {
    if (_playSize == Size.zero || _isGameOver) {
      return;
    }

    final halfSize = _playerSize / 2;
    _playerTargetX = dx.clamp(halfSize, _playSize.width - halfSize);
  }

  void _togglePause() {
    if (_isGameOver) {
      return;
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _restartGame() {
    setState(() {
      _emojis.clear();
      _spawnAccumulator = 0;
      _survivalTime = 0;
      _isRunning = true;
      _isGameOver = false;
      _lastTick = null;
      if (_playSize != Size.zero) {
        _playerCenterX = _playSize.width / 2;
        _playerTargetX = _playerCenterX;
        _spawnOpeningWave();
      }
    });
  }

  void _triggerGameOver() {
    if (_isGameOver) {
      return;
    }
    setState(() {
      _isGameOver = true;
      _isRunning = false;
    });
  }

  void _finishAndExit() {
    if (_resultSent) {
      Navigator.of(context).pop();
      return;
    }

    _resultSent = true;
    Navigator.of(context).pop(_score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final nextSize = Size(constraints.maxWidth, constraints.maxHeight);
          if (nextSize != _playSize) {
            _playSize = nextSize;
            _playerCenterX = _playerCenterX == 0
                ? nextSize.width / 2
                : _playerCenterX.clamp(
                    _playerSize / 2,
                    nextSize.width - (_playerSize / 2),
                  );
            _playerTargetX = _playerTargetX == 0
                ? _playerCenterX
                : _playerTargetX.clamp(
                    _playerSize / 2,
                    nextSize.width - (_playerSize / 2),
                  );
            if (_emojis.isEmpty && !_isGameOver) {
              _spawnOpeningWave();
            }
          }

          return Stack(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (DragStartDetails details) =>
                    _updatePlayerTarget(details.localPosition.dx),
                onHorizontalDragUpdate: (DragUpdateDetails details) =>
                    _updatePlayerTarget(details.localPosition.dx),
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: nextSize,
                    painter: GamePainter(
                      emojis: _emojis,
                      playerCenterX: _playerCenterX,
                      playerSize: _playerSize,
                      playerY: _playerY,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      _HudChip(icon: '⏱️', label: 'Score', value: '$_score'),
                      const Spacer(),
                      _HudChip(
                        icon: '🚀',
                        label: 'Speed',
                        value: _difficulty.toStringAsFixed(1),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: Colors.white.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _togglePause,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              _isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: const Color(0xFF073B4C),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_isRunning && !_isGameOver)
                const _CenterMessage(
                  title: 'Paused',
                  subtitle: 'Tap the play button to jump back in.',
                ),
              if (_isGameOver)
                _GameOverOverlay(
                  score: _score,
                  onRestart: _restartGame,
                  onBackToHome: _finishAndExit,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5C677D),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF073B4C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.18),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF073B4C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5C677D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverOverlay extends StatelessWidget {
  const _GameOverOverlay({
    required this.score,
    required this.onRestart,
    required this.onBackToHome,
  });

  final int score;
  final VoidCallback onRestart;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 24,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('💥', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF073B4C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Final score: $score',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF335C67),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRestart,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEF476F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Restart'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBackToHome,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF073B4C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
