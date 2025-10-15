/*
  file: ai_view_model.dart
  functionality:
    AIService handles the logic for the computer opponent in the Tic Tac Toe game.
    It supports three difficulty levels:
      - Easy: completely random moves.
      - Medium: alternates between random and strategic moves.
      - Hard: uses a basic AI strategy including win/block, forks, center, opposite corner, and sides.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 24/09/2025
*/
import 'dart:math';
import '../model/player_model.dart';
import '../model/game_model.dart';

class AIService {
  final Random _random = Random();

  /*
    Returns the AI's next move index (0–8) based on difficulty and board state.
    [board] - current board state (null for empty, Player.x or Player.o for occupied)
    [aiPlayer] - the AI's symbol (X or O)
    [difficulty] - game difficulty level
    [aiTurnCount] - AI's move count to support medium difficulty alternation
  */
  int getNextMove(
    List<Player?> board,
    Player aiPlayer,
    GameDifficulty difficulty,
    int aiTurnCount,
  ) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return _getRandomMove(board);
      case GameDifficulty.medium:
        // Alternate: first turn random, then hard, then random, etc.
        return aiTurnCount.isEven
            ? _getRandomMove(board)
            : _getHardMove(board, aiPlayer);
      case GameDifficulty.hard:
        return _getHardMove(board, aiPlayer);
    }
  }

  // Returns a random empty cell index on the board
  int _getRandomMove(List<Player?> board) {
    final empty = List.generate(9, (i) => i).where((i) => board[i] == null).toList();
    return empty.isEmpty ? -1 : empty[_random.nextInt(empty.length)];
  }

  // Returns a strategic move index for hard difficulty AI
  int _getHardMove(List<Player?> board, Player aiPlayer) {
    final opponent = aiPlayer == Player.x ? Player.o : Player.x;

    // Step 1: Try to win or block opponent's winning move
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        // Try to win
        board[i] = aiPlayer;
        if (_checkWin(board, aiPlayer)) {
          board[i] = null;
          return i;
        }
        board[i] = null;

        // Try to block
        board[i] = opponent;
        if (_checkWin(board, opponent)) {
          board[i] = null;
          return i;
        }
        board[i] = null;
      }
    }

    // Step 2: Create a fork (two simultaneous winning threats)
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        board[i] = aiPlayer;
        final threats = _countWinningThreats(board, aiPlayer);
        board[i] = null;
        if (threats >= 2) return i;
      }
    }

    // Step 3: Take center if available
    if (board[4] == null) return 4;

    // Step 4: Take opposite corner if opponent is in a corner
    final cornerPairs = {0: 8, 2: 6, 6: 2, 8: 0};
    for (final entry in cornerPairs.entries) {
      if (board[entry.key] == opponent && board[entry.value] == null) {
        return entry.value;
      }
    }

    // Step 5: Take any free corner
    for (final corner in [0, 2, 6, 8]) {
      if (board[corner] == null) return corner;
    }

     // Step 6: Take any free side
    for (final side in [1, 3, 5, 7]) {
      if (board[side] == null) return side;
    }

    // Fallback: random move if no strategic move is found
    return _getRandomMove(board);
  }

  // Counts how many potential winning lines a player has (two in line + one empty)
  int _countWinningThreats(List<Player?> board, Player player) {
    const winLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    int count = 0;
    for (var line in winLines) {
      final values = [board[line[0]], board[line[1]], board[line[2]]];
      if (values.where((p) => p == player).length == 2 &&
          values.contains(null)) {
        count++;
      }
    }
    return count;
  }

  // Checks if [player] has won on the current board
  bool _checkWin(List<Player?> board, Player player) {
    const winLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    return winLines.any((line) => line.every((i) => board[i] == player));
  }
}
