/*
  file: unit_test.dart
  functionality:
    Comprehensive unit tests for the Tic Tac Toe game's core logic.
    Tests cover move validation, undo functionality, win/draw detection, board boundary handling, 
    and AI decision-making across difficulty levels.
    Features:
      - Organized into logical test groups using `group()`
      - Uses `setUp()` for consistent game initialization
      - Verifies both player and AI game flow
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 03/10/2025
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:classic_noughts_and_crosses_game/model/game_model.dart';
import 'package:classic_noughts_and_crosses_game/model/player_model.dart';
import 'package:classic_noughts_and_crosses_game/view_model/game_view_model.dart';
import 'package:classic_noughts_and_crosses_game/view_model/ai_service_view_model.dart';

void main() {
  group('Tic Tac Toe Game Unit Tests', () {
    late GameViewModel game;

    setUp(() {
      final config = GameConfig(
        playerConfig: PlayerConfig(name: 'Tester', symbol: Player.x),
        difficulty: GameDifficulty.easy,
      );
      game = GameViewModel(gameConfig: config, isTestMode: true);
    });

    test('Initial board state', () {
      print('Test: Initial board state');
      expect(game.gameState.board.every((cell) => cell == null), true);
      expect(game.gameState.currentPlayer, Player.x);
      expect(game.isGameOver, false);
      expect(game.gameState.status, GameStatus.playing);
    });

    test('Player can make a valid move', () {
      print('Test: Player can make a valid move');
      expect(game.makeMove(0), true);
      expect(game.gameState.board[0], Player.x);
      expect(game.gameState.currentPlayer, Player.o);
    });

    test('Player cannot move in occupied cell', () {
      print('Test: Player cannot move in occupied cell');
      game.makeMove(0);
      expect(game.makeMove(0), false);
      expect(game.gameState.board[0], Player.x);
    });

    test('Undo restores previous state', () {
      print('Test: Undo restores previous state');
      game.makeMove(0);
      game.makeMove(1);
      game.undoMove();
      expect(game.gameState.board[1], null);
      expect(game.gameState.currentPlayer, Player.o);

      game.undoMove();
      expect(game.gameState.board[0], null);
      expect(game.gameState.currentPlayer, Player.x);
    });

    test('Detect X win', () {
      print('Test: Detect X win');
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X wins
      expect(game.gameState.status, GameStatus.xWon);
      expect(game.isGameOver, true);
    });

    test('Detect O win', () {
      print('Test: Detect O win');
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(7); // X
      game.makeMove(5); // O wins
      expect(game.gameState.status, GameStatus.oWon);
      expect(game.isGameOver, true);
    });

    test('Detect draw', () {
      print('Test: Detect draw');
      final moves = [0, 1, 2, 4, 3, 5, 7, 6, 8];
      for (var move in moves) {
        game.makeMove(move);
      }
      expect(game.gameState.status, GameStatus.draw);
      expect(game.isGameOver, true);
    });

    test('Game reset clears board', () {
      print('Test: Game reset clears board');
      game.makeMove(0);
      game.resetGame();
      expect(game.gameState.board.every((cell) => cell == null), true);
      expect(game.gameState.currentPlayer, Player.x);
      expect(game.isGameOver, false);
      expect(game.gameState.status, GameStatus.playing);
    });

    test('Cannot make move after game over', () {
      print('Test: Cannot make move after game over');
      game.makeMove(0);
      game.makeMove(3);
      game.makeMove(1);
      game.makeMove(4);
      game.makeMove(2); // X wins
      expect(game.makeMove(5), false);
    });

    test('Undo after game over restores playable state', () {
      print('Test: Undo after game over restores playable state');
      game.makeMove(0);
      game.makeMove(3);
      game.makeMove(1);
      game.makeMove(4);
      game.makeMove(2); // X wins
      game.undoMove();
      expect(game.isGameOver, false);
      expect(game.gameState.status, GameStatus.playing);
    });

    test('Board boundaries - invalid indices', () {
      print('Test: Board boundaries - invalid indices');
      expect(game.makeMove(-1), false);
      expect(game.makeMove(9), false);
    });

    test('AI easy mode fills an empty cell', () {
      print('Test: AI easy mode fills an empty cell');
      final aiGame = GameViewModel(
        gameConfig: GameConfig(
          playerConfig: PlayerConfig(name: 'Tester', symbol: Player.o),
          difficulty: GameDifficulty.easy,
        ),
        isTestMode: true,
      );
      aiGame.makeMove(0); // player X
      expect(aiGame.gameState.board.where((c) => c == Player.o).length, 1);
    });

    test('Hard AI takes winning move', () {
      print('Test: Hard AI takes winning move');
      final ai = AIService();
      final board = [
        Player.o,
        Player.o,
        null,
        Player.x,
        Player.x,
        null,
        null,
        null,
        null,
      ];
      final move = ai.getNextMove(board, Player.o, GameDifficulty.hard, 0);
      expect(move, 2); // AI should take winning move
    });
  });
}
