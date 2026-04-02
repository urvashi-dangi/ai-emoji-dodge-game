import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.bestScore,
    required this.lastScore,
    required this.onStartGame,
    super.key,
  });

  final int bestScore;
  final int? lastScore;
  final Future<void> Function() onStartGame;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final contentMinHeight = (viewportHeight - 48).clamp(0.0, double.infinity);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFFF1C1),
              Color(0xFFFFD6A5),
              Color(0xFFFFCAD4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: contentMinHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.82),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 24,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            const Text('😎', style: TextStyle(fontSize: 72)),
                            const SizedBox(height: 12),
                            Text(
                              'Emoji Dodge',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF073B4C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Drag to dodge the emoji storm and survive as long as you can.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF335C67),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: _ScoreCard(
                                    label: 'Best',
                                    value: '$bestScore',
                                    color: const Color(0xFF2EC4B6),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ScoreCard(
                                    label: 'Last',
                                    value: '${lastScore ?? 0}',
                                    color: const Color(0xFFFF9F1C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: onStartGame,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF476F),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  textStyle: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                child: const Text('Start Game'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Move with your finger. Pause any time from the top-right button.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF5C677D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF335C67),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF073B4C),
            ),
          ),
        ],
      ),
    );
  }
}
