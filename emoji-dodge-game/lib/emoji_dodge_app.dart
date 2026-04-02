import 'package:flutter/material.dart';

import 'src/screens/game_screen.dart';
import 'src/screens/home_screen.dart';

class EmojiDodgeApp extends StatefulWidget {
  const EmojiDodgeApp({super.key});

  @override
  State<EmojiDodgeApp> createState() => _EmojiDodgeAppState();
}

class _EmojiDodgeAppState extends State<EmojiDodgeApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _bestScore = 0;
  int? _lastScore;
  Route<int>? _activeGameRoute;

  Future<void> _openGame() async {
    if (_activeGameRoute != null) {
      return;
    }

    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    final route = MaterialPageRoute<int>(
      builder: (_) => const GameScreen(),
      settings: const RouteSettings(name: GameScreen.routeName),
    );
    _activeGameRoute = route;

    int? result;
    try {
      result = await navigator.push<int>(route);
    } finally {
      _activeGameRoute = null;
    }

    if (!mounted || result == null) {
      return;
    }

    _handleGameResult(result);
  }

  void _handleGameResult(int result) {
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
      navigatorKey: _navigatorKey,
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
      home: HomeScreen(
        bestScore: _bestScore,
        lastScore: _lastScore,
        onStartGame: _openGame,
      ),
    );
  }
}
