import 'dart:math';
import '../model/player_model.dart';
import '../model/game_model.dart';

class AIService {
  final Random _random = Random();

  /// Returns the AI's next move index (0–8) based on difficulty and board state.
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
        return aiTurnCount.isEven
            ? _getRandomMove(board)
            : _getHardMove(board, aiPlayer);
      case GameDifficulty.hard:
        return _getHardMove(board, aiPlayer);
    }
  }

  int _getRandomMove(List<Player?> board) {
    final empty = List.generate(9, (i) => i).where((i) => board[i] == null).toList();
    return empty.isEmpty ? -1 : empty[_random.nextInt(empty.length)];
  }

  int _getHardMove(List<Player?> board, Player aiPlayer) {
    final opponent = aiPlayer == Player.x ? Player.o : Player.x;

    // Step 1: Win or block
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

    // Step 2: Fork — find a move that gives AI two winning threats
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        board[i] = aiPlayer;
        final threats = _countWinningThreats(board, aiPlayer);
        board[i] = null;
        if (threats >= 2) {
          return i;
        }
      }
    }

    // Step 3: Center
    if (board[4] == null) return 4;

    // Step 4: Opposite corner
    final cornerPairs = {0: 8, 2: 6, 6: 2, 8: 0};
    for (final entry in cornerPairs.entries) {
      if (board[entry.key] == opponent && board[entry.value] == null) {
        return entry.value;
      }
    }

    // Step 5: Any free corner
    for (final corner in [0, 2, 6, 8]) {
      if (board[corner] == null) return corner;
    }

    // Step 6: Any side
    for (final side in [1, 3, 5, 7]) {
      if (board[side] == null) return side;
    }

    // Fallback (should not happen)
    return _getRandomMove(board);
  }

  /// Counts how many lines the player can win in one move (i.e., has 2 in a line with 1 empty)
  int _countWinningThreats(List<Player?> board, Player player) {
    const winLines = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
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

  bool _checkWin(List<Player?> board, Player player) {
    const winLines = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ];
    return winLines.any((line) =>
        line.every((i) => board[i] == player));
  }
}