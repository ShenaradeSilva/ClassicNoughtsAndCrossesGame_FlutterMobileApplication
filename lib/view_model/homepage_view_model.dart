/*
  file: homepagee_view_model.dart
  functionality:
    Tracks player name, profile selection, and chosen symbol.
    Tracks game difficulty and form visibility.
    Provides validation for form inputs
    Prepares GameConfig object to start the game.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 21/09/2025
*/

import 'package:flutter/foundation.dart';
import '../model/player_model.dart';
import '../model/game_model.dart';

class HomepageViewModel with ChangeNotifier {
  String _playerName = '';
  String? _selectedDifficulty;
  bool _showGameSetup = false;
  PlayerProfile? _selectedProfile;
  Player? _chosenSymbol;

  // Getters
  String get playerName => _playerName;
  String? get selectedDifficulty => _selectedDifficulty;
  bool get showGameSetup => _showGameSetup;
  PlayerProfile? get selectedProfile => _selectedProfile;
  Player? get chosenSymbol => _chosenSymbol;

  // Returns true if player name and difficulty are set
  bool get isFormValid => _playerName.isNotEmpty && _selectedDifficulty != null;

  // Updates the player's name
  void setPlayerName(String name) {
    _playerName = name;
    notifyListeners();
  }

  // Updates selected difficulty
  void setSelectedDifficulty(String? difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  // Shows or hides the game setup UI
  void setShowGameSetup(bool show) {
    _showGameSetup = show;
    notifyListeners();
  }

  // Updates the selected profile
  void setSelectedProfile(PlayerProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  // Updates the chosen symbol (X or O)
  void setChosenSymbol(Player? symbol) {
    _chosenSymbol = symbol;
    notifyListeners();
  }

  // Resets all form fields and selections
  void resetForm() {
    _playerName = '';
    _selectedDifficulty = null;
    _showGameSetup = false;
    _selectedProfile = null;
    _chosenSymbol = null;
    notifyListeners();
  }

  // Converts string difficulty to GameDifficulty enum
  GameDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return GameDifficulty.easy;
      case 'medium':
        return GameDifficulty.medium;
      case 'hard':
        return GameDifficulty.hard;
      default:
        return GameDifficulty.medium;       // default to medium if unknown
    }
  }

  // Returns a GameConfig object if form is valid and symbol is chosen
  GameConfig? getGameConfig() {
    if (!isFormValid || _chosenSymbol == null) return null;

    final playerConfig = PlayerConfig(
      name: _playerName,
      symbol: _chosenSymbol!,
      profile: _selectedProfile,
    );

    return GameConfig(
      playerConfig: playerConfig,
      difficulty: _parseDifficulty(_selectedDifficulty!),
    );       
  }
}
