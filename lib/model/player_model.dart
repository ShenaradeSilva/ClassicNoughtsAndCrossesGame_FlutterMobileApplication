/*
  file: player_model.dart
  functionality:
    Defines the data models for the players in the Noughts and Crosses game.
    Includes:
      - `Player`: Enum for X and O symbols.
      - `PlayerProfile`: Optional enum for player type (human gender or AI).
      - `PlayerConfig`: Immutable configuration for each player including name, symbol, and optional profile.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 20/09/2025
*/

enum Player { x, o }        // Represents the two possible players in the game.

enum PlayerProfile { male, female, ai }     // Represents optional profiles for players (human or AI).

// Configuration for a player, including name, symbol, and optional profile.
class PlayerConfig {
  final String name;
  final Player symbol;            // The symbol used by the player (X or O).
  final PlayerProfile? profile;   // Optional profile for the player (player or AI type).

  const PlayerConfig({
    required this.name,
    required this.symbol,
    this.profile,
  });
}
