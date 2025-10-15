/*
  file: game_view_model.dart
  functionality:
    Tracks the game board, current player, and game status.
    Handles player and AI moves.
    Supports undo functionality.
    Determines win/draw conditions.
    Works with AIService for AI moves based on difficulty.
    Features:
      - AI first move support if player chooses 'O'.
      - Configurable AI difficulty (Easy, Medium, Hard).
      - Test mode to disable AI auto-moves for unit testing.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 23/09/2025
*/

import 'package:flutter/foundation.dart';
import 'package:classic_noughts_and_crosses_game/model/game_model.dart';
import 'package:classic_noughts_and_crosses_game/model/player_model.dart';
import 'ai_service_view_model.dart';

// Internal class to save a snapshot of the board state
class _BoardSnapshot {
  final List<Player?> board;
  final Player currentPlayer;
  final bool isAIMove; // Indicates if this snapshot is an AI move

  _BoardSnapshot(this.board, this.currentPlayer, {this.isAIMove = false});
}

class GameViewModel with ChangeNotifier {
  final GameConfig _gameConfig;
  GameState _gameState;
  final List<_BoardSnapshot> _moveHistory = [];       // Stores previous moves for undo
  int _aiTurnCount = 0;                               // Count AI turns for medium difficulty
  bool _isAITurn = false;                             // Flag to block player input during AI turn
  final AIService _aiService = AIService();           // AI decision engine
  final bool isTestMode;                              // For unit tests

  // Constructor: sets initial game state
  GameViewModel({required GameConfig gameConfig, this.isTestMode = false})
    : _gameConfig = gameConfig,
      _gameState = GameState.initial(gameConfig.playerConfig.symbol) {
    if (_shouldAIPlayFirst() && !isTestMode) {
      _makeAIMove();
    }
  }

  // Getters
  GameConfig get gameConfig => _gameConfig;
  GameState get gameState => _gameState;
  bool get isGameOver => _gameState.isGameOver;

  // Can undo if there is history, game is not over, and it's not AI's turn
  bool get canUndo =>
      _moveHistory.isNotEmpty && !_gameState.isGameOver && !_isAITurn;

  // Returns the AI player symbol
  Player _getAIPlayer() =>
      _gameConfig.playerConfig.symbol == Player.x ? Player.o : Player.x;

  // Checks if AI should play first
  bool _shouldAIPlayFirst() => _gameConfig.playerConfig.symbol == Player.o;

  // Player makes a move at [index]; returns true if move was valid
  bool makeMove(int index) {
    if (index < 0 || index >= _gameState.board.length) return false;
    if (_isAITurn || _gameState.board[index] != null || _gameState.isGameOver)
      return false;

    _saveCurrentBoard(isAIMove: false);         // Save player move

    final newBoard = List<Player?>.from(_gameState.board);
    newBoard[index] = _gameState.currentPlayer;

    final newStatus = _checkWinner(newBoard, _gameState.currentPlayer);

    _gameState = _gameState.copyWith(
      board: newBoard,
      currentPlayer: _switchPlayer(_gameState.currentPlayer),
      status: newStatus,
      resultMessage: _getResultMessage(newStatus),
    );

    notifyListeners();

    // Trigger AI move
    if (!isTestMode &&
        !_gameState.isGameOver &&
        _gameState.currentPlayer == _getAIPlayer()) {
      _makeAIMove();
      notifyListeners();
    }

    return true;
  }

  // Manual trigger for AI moves (used in unit tests)
  void performAIMove() {
    if (!_gameState.isGameOver &&
        !_isAITurn &&
        _gameState.currentPlayer == _getAIPlayer()) {
      _makeAIMove();
      notifyListeners();
    }
  }

  // Internal AI move logic
  Future<void> _makeAIMove() async {
    if (_gameState.isGameOver) return;

    _isAITurn = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final aiMove = _aiService.getNextMove(
      _gameState.board,
      _getAIPlayer(),
      _gameConfig.difficulty,
      _aiTurnCount,
    );

    if (aiMove == -1) {
      _isAITurn = false;
      notifyListeners();
      return;
    }

    _saveCurrentBoard(isAIMove: true); // Save AI move

    final newBoard = List<Player?>.from(_gameState.board);
    newBoard[aiMove] = _getAIPlayer();

    final newStatus = _checkWinner(newBoard, _getAIPlayer());

    _gameState = _gameState.copyWith(
      board: newBoard,
      currentPlayer: _gameConfig.playerConfig.symbol,
      status: newStatus,
      resultMessage: _getResultMessage(newStatus),
    );

    _aiTurnCount++;
    _isAITurn = false;
    notifyListeners();
  }

  // Undo move (player-only or full turn)
  void undoMove() {
    if (_moveHistory.isEmpty || _isAITurn) return;

    final lastMove = _moveHistory.removeLast();

    if (lastMove.isAIMove) {
      // Check if there is a previous player move to undo together
      if (_moveHistory.isNotEmpty && !_moveHistory.last.isAIMove) {
        final playerMove = _moveHistory.removeLast();
        _gameState = _gameState.copyWith(
          board: List<Player?>.from(playerMove.board),
          currentPlayer: playerMove.currentPlayer,
          status: GameStatus.playing,
          resultMessage: '',
        );
      } else {
        // AI move is first move; cannot undo
        _moveHistory.add(lastMove); // restore it
        return;
      }
    } else {
      // Undo player move only
      _gameState = _gameState.copyWith(
        board: List<Player?>.from(lastMove.board),
        currentPlayer: lastMove.currentPlayer,
        status: GameStatus.playing,
        resultMessage: '',
      );
    }

    notifyListeners();
  }

  // Reset game
  void resetGame() {
    _moveHistory.clear();
    _aiTurnCount = 0;
    _isAITurn = false;
    _gameState = GameState.initial(_gameConfig.playerConfig.symbol);

    if (_shouldAIPlayFirst() && !isTestMode) _makeAIMove();

    notifyListeners();
  }

  // Save board snapshot
  void _saveCurrentBoard({required bool isAIMove}) {
    _moveHistory.add(
      _BoardSnapshot(
        List<Player?>.from(_gameState.board),
        _gameState.currentPlayer,
        isAIMove: isAIMove,
      ),
    );
  }

  // Winner or draw detection
  GameStatus _checkWinner(List<Player?> board, Player player) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var line in lines) {
      if (line.every((i) => board[i] == player)) {
        return player == Player.x ? GameStatus.xWon : GameStatus.oWon;
      }
    }

    if (!board.contains(null)) return GameStatus.draw;
    return GameStatus.playing;
  }

  // Switch player
  Player _switchPlayer(Player player) =>
      player == Player.x ? Player.o : Player.x;

  // Display result message
  String _getResultMessage(GameStatus status) {
    switch (status) {
      case GameStatus.xWon:
        return _gameConfig.playerConfig.symbol == Player.x
            ? 'You Win!'
            : 'AI Wins!';
      case GameStatus.oWon:
        return _gameConfig.playerConfig.symbol == Player.o
            ? 'You Win!'
            : 'AI Wins!';
      case GameStatus.draw:
        return 'Draw!';
      case GameStatus.playing:
        return '';
    }
  }
}
