import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classic_noughts_and_crosses_game/view/homepage_view.dart';
import 'package:classic_noughts_and_crosses_game/view_model/homepage_view_model.dart';
import 'package:classic_noughts_and_crosses_game/view_model/stats_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize StatsViewModel
  final statsVM = StatsViewModel();

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
