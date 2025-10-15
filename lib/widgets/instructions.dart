/*
  file: instructions.dart
  functionality:
    Provides step-by-step instructions explaining gameplay rules and options such as difficulty levels and symbol selection.
    The layout uses Flutter’s Material widgets for consistency and includes a custom-styled AppBar and scrollable text content 
    for readability.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 01/10/2025
*/

import 'package:flutter/material.dart';

// A simple static view that explains how to play the Tic Tac Toe game.
class InstructionsView extends StatelessWidget {
  const InstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // AppBar with centered title and custom back button
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        automaticallyImplyLeading: false,         // disable default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("How to Play", style: TextStyle(color: Colors.white)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),      // Go back to previous screen
        ),
      ),
      // Scrollable body with step-by-step instructions
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 80),
              Text(
                "1. The game is played on a 3x3 grid against AI.\n\n"
                "2. There are 3 difficulty levels that you can select - Easy, Medium and Hard.\n\n"
                "3. You can select either X or O.\n\n"
                "4. Players take turns placing their symbol in empty squares.\n\n"
                "5. The first player to get 3 in a row (horizontally, vertically, or diagonally) wins.\n\n"
                "6. If all 9 squares are filled and no one has 3 in a row, the game ends in a draw.\n\n",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),
              // Closing note
              Center(
                child: Text(
                  "Good Luck & Have Fun!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
