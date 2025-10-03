import 'package:flutter/foundation.dart';
import 'package:classic_noughts_and_crosses_game/model/game_model.dart';
import 'package:classic_noughts_and_crosses_game/model/player_model.dart';
import 'ai_service_view_model.dart';

class GameViewModel with ChangeNotifier {
  final GameConfig _gameConfig;
  GameState _gameState;
  final List<List<Player?>> _moveHistory = [];
  int _aiTurnCount = 0;
  bool _isAITurn = false;
  final AIService _aiService = AIService();

  GameViewModel({required GameConfig gameConfig})
      : _gameConfig = gameConfig,
        _gameState = GameState.initial(gameConfig.playerConfig.symbol) {
    if (_shouldAIPlayFirst()) {
      _makeAIMove();
    }
  }

  // Getters
  GameConfig get gameConfig => _gameConfig;
  GameState get gameState => _gameState;
  bool get isGameOver => _gameState.isGameOver;
  bool get canUndo => _moveHistory.isNotEmpty && !_gameState.isGameOver && !_isAITurn;

  bool _shouldAIPlayFirst() => _gameConfig.playerConfig.symbol == Player.o;
  Player _getAIPlayer() => _gameConfig.playerConfig.symbol == Player.x ? Player.o : Player.x;

  void makeMove(int index) {
    if (_isAITurn || _gameState.board[index] != null || _gameState.isGameOver) return;

    _saveCurrentBoard();

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

    if (newStatus == GameStatus.playing && _gameState.currentPlayer == _getAIPlayer()) {
      _makeAIMove();
    }
  }

  void _makeAIMove() {
    if (_gameState.isGameOver) return;

    _isAITurn = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_gameState.isGameOver) {
        _isAITurn = false;
        notifyListeners();
        return;
      }

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

      _saveCurrentBoard();

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
    });
  }

  void undoMove() {
    if (_moveHistory.isEmpty || _gameState.isGameOver || _isAITurn) return;

    final isPlayerTurn = _gameState.currentPlayer == _gameConfig.playerConfig.symbol;

    if (isPlayerTurn && _moveHistory.length >= 2) {
      _moveHistory.removeLast(); 
      final prevState = _moveHistory.removeLast();
      _restoreBoard(prevState, _gameConfig.playerConfig.symbol);
      _aiTurnCount = _aiTurnCount > 0 ? _aiTurnCount - 1 : 0;
    } else {
      final prevState = _moveHistory.removeLast();
      _restoreBoard(prevState, _getAIPlayer());
    }

    notifyListeners();
  }

  void resetGame() {
    _moveHistory.clear();
    _aiTurnCount = 0;
    _isAITurn = false;
    _gameState = GameState.initial(_gameConfig.playerConfig.symbol);

    if (_shouldAIPlayFirst()) _makeAIMove();

    notifyListeners();
  }

  void _saveCurrentBoard() {
    _moveHistory.add(List<Player?>.from(_gameState.board));
  }

  void _restoreBoard(List<Player?> board, Player nextPlayer) {
    _gameState = _gameState.copyWith(
      board: List<Player?>.from(board),
      currentPlayer: nextPlayer,
      status: GameStatus.playing,
      resultMessage: '',
    );
  }

  GameStatus _checkWinner(List<Player?> board, Player player) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var line in lines) {
      if (line.every((i) => board[i] == player)) {
        return player == Player.x ? GameStatus.xWon : GameStatus.oWon;
      }
    }

    if (!board.contains(null)) return GameStatus.draw;
    return GameStatus.playing;
  }

  Player _switchPlayer(Player player) => player == Player.x ? Player.o : Player.x;

  String _getResultMessage(GameStatus status) {
    switch (status) {
      case GameStatus.xWon:
        return _gameConfig.playerConfig.symbol == Player.x ? 'You Win!' : 'AI Wins!';
      case GameStatus.oWon:
        return _gameConfig.playerConfig.symbol == Player.o ? 'You Win!' : 'AI Wins!';
      case GameStatus.draw:
        return 'Draw!';
      case GameStatus.playing:
        return '';
    }
  }
}
