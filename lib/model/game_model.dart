/*
  file: game_model.dart
  functionality:
    Defines the core data models for the Noughts and Crosses (Tic-Tac-Toe) game.
    Includes:
      - `GameConfig`: Holds configuration such as players and difficulty.
      - `GameState`: Immutable representation of the current board, current player, game status, and result message.
      - `GameDifficulty` and `GameStatus`: Enumerations for AI difficulty and game outcome.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 23/09/2025
*/

import 'package:classic_noughts_and_crosses_game/model/player_model.dart';

enum GameDifficulty { easy, medium, hard }    // Difficulty levels for AI gameplay.
enum GameStatus { playing, xWon, oWon, draw } // Current status of the game.

// Configuration for a game session, including players and difficulty.
class GameConfig {
  final PlayerConfig playerConfig;
  final GameDifficulty difficulty;

  const GameConfig({
    required this.playerConfig,
    required this.difficulty,
  });
}

// Represents the state of the game at any point in time.
class GameState {
  final List<Player?> board;        // 3x3 board represented as a list of 9 elements (null if empty).
  final Player currentPlayer;       // The player whose turn it is currently.
  final GameStatus status;          // Current status of the game (playing, draw, or won).
  final String resultMessage;       // Message to display at the end of the game

  const GameState({
    required this.board,
    required this.currentPlayer,
    required this.status,
    required this.resultMessage,
  });

  // Creates an initial empty game board starting with [startingPlayer].
  GameState.initial(Player startingPlayer)
      : board = List.filled(9, null),
        currentPlayer = startingPlayer,
        status = GameStatus.playing,
        resultMessage = '';

  // Returns a copy of the current state with optional updated fields.
  GameState copyWith({
    List<Player?>? board,
    Player? currentPlayer,
    GameStatus? status,
    String? resultMessage,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      resultMessage: resultMessage ?? this.resultMessage,
    );
  }

  // Returns true if the game is over (win or draw).
  bool get isGameOver => status != GameStatus.playing;
}
