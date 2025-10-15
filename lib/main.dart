/*
  file: main.dart
  functionality:
    Entry point of the Classic Noughts and Crosses game (Tic Tac Toe).
    Initializes the Flutter app, sets up state management using the Provider package, and applies the global theme and gradient.
    Features:
      - Uses MultiProvider to manage global app state.
      - Initializes the StatsViewModel for game statistics persistence.
      - Sets up a consistent gradient background for the entire app.
      - Launches the HomepageView as the app’s starting screen.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 20/09/2025
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classic_noughts_and_crosses_game/view/homepage_view.dart';
import 'package:classic_noughts_and_crosses_game/view_model/homepage_view_model.dart';
import 'package:classic_noughts_and_crosses_game/view_model/stats_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();      // Ensure Flutter bindings before app run

  // Initialize StatsViewModel
  final statsVM = StatsViewModel();

  // Provide global state management for homepage and stats
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomepageViewModel>(
          create: (_) => HomepageViewModel(),
        ),
        ChangeNotifierProvider<StatsViewModel>.value(
          value: statsVM,
        ),
      ],
      child: const TicTacToeApp(),
    ),
  );
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 237, 42, 247),
                Color.fromARGB(255, 97, 0, 89),
              ],
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomepageView(),
    );
  }
}
