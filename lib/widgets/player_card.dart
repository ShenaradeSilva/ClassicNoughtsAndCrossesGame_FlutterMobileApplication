import 'package:flutter/material.dart';
import '../model/player_model.dart';

class PlayerCard extends StatelessWidget {
  final String name;
  final PlayerProfile? profile;
  final bool isSmall;
  final Player? symbol; // Nullable symbol

  const PlayerCard({
    super.key, 
    required this.name, 
    required this.profile,
    this.isSmall = false,
    this.symbol, // optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 16, 
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile image or default icon
          if (profile != null) ...[
            Container(
              width: isSmall ? 24 : 32,
              height: isSmall ? 24 : 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    profile == PlayerProfile.male 
                      ? 'assets/male.png' 
                      : 'assets/female.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            Container(
              width: isSmall ? 24 : 32,
              height: isSmall ? 24 : 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.person,
                size: isSmall ? 16 : 20,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Player name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isNotEmpty ? name : 'Player',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: isSmall ? 14 : 16,
                ),
              ),
              // Symbol display if not null
              if (symbol != null)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    symbol!.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
