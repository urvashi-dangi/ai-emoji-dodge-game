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
  bool _isOpeningGame = false;
  Route<int>? _activeGameRoute;

  Future<void> _openGame() async {
    // Prevent multiple game screens opening
    if (_isOpeningGame || _activeGameRoute != null) return;
    _isOpeningGame = true;

    // On a fresh install / first launch, wait until the first frame settles
    // so the root navigator is definitely attached.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      _isOpeningGame = false;
      return;
    }

    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      _isOpeningGame = false;
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
      _isOpeningGame = false;
    }

    if (!mounted || result == null) return;

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
