import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/stats_view_model.dart';
import '../model/player_model.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Widget _profileImage(PlayerProfile? profile, double size) {
    if (profile == null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
      );
    }

    String imagePath;
    switch (profile) {
      case PlayerProfile.male:
        imagePath = 'assets/male.png';
        break;
      case PlayerProfile.female:
        imagePath = 'assets/female.png';
        break;
      case PlayerProfile.ai:
        imagePath = 'assets/ai.png';
        break;
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(imagePath),
    );
  }

  Widget _buildStatRow(String stat, int playerValue, int aiValue) {
    return Row(
      children: [
        Expanded(
          child: Text(
            stat,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Text(
            playerValue.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            aiValue.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsVM = Provider.of<StatsViewModel>(context);

    final aiWins = statsVM.losses;
    final aiLosses = statsVM.wins;
    final aiDraws = statsVM.draws;

    String winnerName;
    PlayerProfile? winnerProfile;
    String cardMessage;
    Color cardColor;
    bool isDraw = false;

    if (statsVM.lastResult == true) {
      winnerName = statsVM.lastUserName.isNotEmpty
          ? statsVM.lastUserName
          : 'You';
      winnerProfile = statsVM.lastUserProfile;
      cardColor = Colors.pink;
      cardMessage = "CONGRATULATIONS!!";
    } else if (statsVM.lastResult == false) {
      winnerName = statsVM.lastAIName.isNotEmpty ? statsVM.lastAIName : 'AI';
      winnerProfile = statsVM.lastAIProfile ?? PlayerProfile.ai;
      cardColor = Colors.cyan;
      cardMessage = "GAME OVER!!";
    } else {
      winnerName = 'Drawn';
      winnerProfile = null;
      cardColor = Colors.purple.shade200;
      cardMessage = "GAME DRAWN!!!";
      isDraw = true;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.purple[700],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Game Results",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: 260,
              height: 260,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (isDraw)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _profileImage(statsVM.lastUserProfile, 60),
                        const SizedBox(width: 16),
                        _profileImage(
                          statsVM.lastAIProfile ?? PlayerProfile.ai,
                          60,
                        ),
                      ],
                    )
                  else
                    _profileImage(winnerProfile, 72),
                  const SizedBox(height: 12),
                  Text(
                    winnerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Back to Game"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: Column(
                          children: [
                            _profileImage(statsVM.lastUserProfile, 48),
                            const SizedBox(height: 4),
                            Text(
                              statsVM.lastUserName.isNotEmpty
                                  ? statsVM.lastUserName
                                  : 'You',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _profileImage(
                              statsVM.lastAIProfile ?? PlayerProfile.ai,
                              48,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statsVM.lastAIName.isNotEmpty
                                  ? statsVM.lastAIName
                                  : 'AI',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStatRow('Wins', statsVM.wins, aiWins),
                  const SizedBox(height: 8),
                  _buildStatRow('Losses', statsVM.losses, aiLosses),
                  const SizedBox(height: 8),
                  _buildStatRow('Draws', statsVM.draws, aiDraws),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
