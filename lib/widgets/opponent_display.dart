import 'package:flutter/material.dart';
import '../model/player_model.dart';
import '../model/game_model.dart';

class OpponentDisplay extends StatelessWidget {
  final PlayerConfig playerConfig;
  final GameDifficulty difficulty;

  const OpponentDisplay({
    super.key,
    required this.playerConfig,
    required this.difficulty,
  });

  String _getDifficultyText() {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'EASY';
      case GameDifficulty.medium:
        return 'MEDIUM';
      case GameDifficulty.hard:
        return 'HARD';
    }
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }

  Player _getAISymbol() {
    return playerConfig.symbol == Player.x ? Player.o : Player.x;
  }

  @override
  Widget build(BuildContext context) {
    final aiSymbol = _getAISymbol();

    return Container(
      margin: const EdgeInsets.only(top: 2), // Space for the badge to overlap
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Main content card (behind the badge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            margin: const EdgeInsets.only(top: 15), // Space for badge to overlap
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Player Card
                _buildPlayerCard(
                  name: playerConfig.name,
                  profile: playerConfig.profile,
                  symbol: playerConfig.symbol,
                  isPlayer: true,
                ),

                // VS text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // AI Card
                _buildPlayerCard(
                  name: 'AI',
                  profile: null,
                  symbol: aiSymbol,
                  isPlayer: false,
                ),
              ],
            ),
          ),

          // Level badge (on top)
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _getDifficultyColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Level: ${_getDifficultyText()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required PlayerProfile? profile,
    required Player symbol,
    required bool isPlayer,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isPlayer ? Colors.pink : Colors.cyan,
                width: 2,
              ),
              image: isPlayer
                  ? (profile != null
                      ? DecorationImage(
                          image: AssetImage(
                            profile == PlayerProfile.male
                                ? 'assets/male.png'
                                : 'assets/female.png',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null)
                  : const DecorationImage(
                      image: AssetImage('assets/ai.png'),
                      fit: BoxFit.cover,
                    ),
            ),
            child: profile == null && isPlayer
                ? const Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.white,
                  )
                : null,
          ),

          const SizedBox(height: 6),

          // Name
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Symbol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isPlayer ? Colors.pink.withOpacity(0.9) : Colors.cyan.withOpacity(0.9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              symbol.name.toUpperCase(),
              style: TextStyle(
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}