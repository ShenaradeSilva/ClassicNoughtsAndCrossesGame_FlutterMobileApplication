import 'package:classic_noughts_and_crosses_game/model/player_model.dart';

enum GameDifficulty { easy, medium, hard }
enum GameStatus { playing, xWon, oWon, draw }

class GameConfig {
  final PlayerConfig playerConfig;
  final GameDifficulty difficulty;

  const GameConfig({
    required this.playerConfig,
    required this.difficulty,
  });
}

class GameState {
  final List<Player?> board;
  final Player currentPlayer;
  final GameStatus status;
  final String resultMessage;

  const GameState({
    required this.board,
    required this.currentPlayer,
    required this.status,
    required this.resultMessage,
  });

  GameState.initial(Player startingPlayer)
      : board = List.filled(9, null),
        currentPlayer = startingPlayer,
        status = GameStatus.playing,
        resultMessage = '';

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

  bool get isGameOver => status != GameStatus.playing;
}
