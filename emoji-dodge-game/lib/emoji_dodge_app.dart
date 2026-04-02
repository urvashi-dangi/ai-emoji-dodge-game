import 'package:flutter/material.dart';

import 'src/screens/game_screen.dart';
import 'src/screens/home_screen.dart';

class EmojiDodgeApp extends StatefulWidget {
  const EmojiDodgeApp({super.key});

  @override
  State<EmojiDodgeApp> createState() => _EmojiDodgeAppState();
}

class _EmojiDodgeAppState extends State<EmojiDodgeApp> {
  int _bestScore = 0;
  int? _lastScore;

  Future<void> _openGame(BuildContext context) async {
    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(builder: (_) => const GameScreen()),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _lastScore = result;
      if (result > _bestScore) {
        _bestScore = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emoji Dodge',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB703),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF7E8),
      ),
      home: Builder(
        builder: (BuildContext homeContext) => HomeScreen(
          bestScore: _bestScore,
          lastScore: _lastScore,
          onStartGame: () => _openGame(homeContext),
        ),
      ),
    );
  }
}
