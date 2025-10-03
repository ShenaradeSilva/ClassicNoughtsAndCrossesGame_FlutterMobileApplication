enum Player { x, o }

enum PlayerProfile { male, female, ai }

class PlayerConfig {
  final String name;
  final Player symbol;
  final PlayerProfile? profile;

  const PlayerConfig({
    required this.name,
    required this.symbol,
    this.profile,
  });
}
