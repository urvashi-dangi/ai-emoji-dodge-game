import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emoji_dodge_game/emoji_dodge_app.dart';

void main() {
  testWidgets('home screen renders game title and start button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmojiDodgeApp());

    expect(find.text('Emoji Dodge'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('Best'), findsOneWidget);
  });

  testWidgets('start game navigates to the game screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmojiDodgeApp());

    await tester.tap(find.text('Start Game'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Score'), findsOneWidget);
    expect(find.text('Speed'), findsOneWidget);
  });

  testWidgets('game can be opened again after returning home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmojiDodgeApp());

    await tester.tap(find.text('Start Game'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Score'), findsOneWidget);

    final navigatorState = tester.state<NavigatorState>(find.byType(Navigator));
    navigatorState.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Start Game'), findsOneWidget);

    await tester.tap(find.text('Start Game'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Score'), findsOneWidget);
  });

  testWidgets('repeated start taps still leave navigation usable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmojiDodgeApp());

    await tester.tap(find.text('Start Game'));
    await tester.tap(find.text('Start Game'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Score'), findsOneWidget);

    final navigatorState = tester.state<NavigatorState>(find.byType(Navigator));
    navigatorState.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Start Game'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Score'), findsOneWidget);
  });
}
