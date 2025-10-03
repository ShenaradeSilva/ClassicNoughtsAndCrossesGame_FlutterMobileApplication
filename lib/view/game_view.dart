import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/game_model.dart';
import '../model/player_model.dart';
import '../view_model/game_view_model.dart';
import '../view_model/stats_view_model.dart';
import '../widgets/player_card.dart';
import '../widgets/opponent_display.dart';
import 'stats_view.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  Widget _buildAppBarPlayerWidget(String playerName, PlayerProfile? profile) {
    return PlayerCard(name: playerName, profile: profile, isSmall: true);
  }

  Widget _buildCell(int index, GameViewModel viewModel) {
    final cellPlayer = viewModel.gameState.board[index];
    if (cellPlayer == null) {
      return GestureDetector(
        onTap: () => viewModel.makeMove(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    final isPlayerMark = cellPlayer == viewModel.gameConfig.playerConfig.symbol;
    final symbolColor = isPlayerMark ? Colors.pinkAccent : Colors.cyanAccent;

    return GestureDetector(
      onTap: () => viewModel.makeMove(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            cellPlayer.name.toUpperCase(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: symbolColor,
            ),
          ),
        ),
      ),
    );
  }

  void _updateStatsAfterBuild(BuildContext context, GameViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final statsVM = Provider.of<StatsViewModel>(context, listen: false);
      final config = viewModel.gameConfig;
      final status = viewModel.gameState.status;

      final userName = config.playerConfig.name;
      final userProfile = config.playerConfig.profile;
      final userSymbol = config.playerConfig.symbol;

      if (status == GameStatus.draw) {
        statsVM.addDraw(userName: userName, profile: userProfile, userSymbol: userSymbol);
      } else if ((status == GameStatus.xWon && userSymbol == Player.x) ||
          (status == GameStatus.oWon && userSymbol == Player.o)) {
        statsVM.addWin(userName: userName, profile: userProfile, userSymbol: userSymbol);
      } else {
        statsVM.addLoss(userName: userName, profile: userProfile, userSymbol: userSymbol);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final playerConfig = viewModel.gameConfig.playerConfig;

        if (viewModel.isGameOver) _updateStatsAfterBuild(context, viewModel);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.purple[700],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        const Text(
                          'Tic Tac Toe Game',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        _buildAppBarPlayerWidget(playerConfig.name, playerConfig.profile),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OpponentDisplay(
                    playerConfig: playerConfig,
                    difficulty: viewModel.gameConfig.difficulty,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) => _buildCell(index, viewModel),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IgnorePointer(
                        ignoring: viewModel.isGameOver,
                        child: Opacity(
                          opacity: viewModel.isGameOver ? 0.4 : 1.0,
                          child: ElevatedButton(
                            onPressed:
                                !viewModel.isGameOver && viewModel.canUndo ? viewModel.undoMove : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.undo, size: 20),
                                SizedBox(width: 8),
                                Text('Undo Move', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: viewModel.resetGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh, size: 20),
                            SizedBox(width: 8),
                            Text('Restart Game', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
