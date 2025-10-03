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

  bool get isFormValid => _playerName.isNotEmpty && _selectedDifficulty != null;

  // Setters
  void setPlayerName(String name) {
    _playerName = name;
    notifyListeners();
  }

  void setSelectedDifficulty(String? difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setShowGameSetup(bool show) {
    _showGameSetup = show;
    notifyListeners();
  }

  void setSelectedProfile(PlayerProfile? profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  void setChosenSymbol(Player? symbol) {
    _chosenSymbol = symbol;
    notifyListeners();
  }

  void resetForm() {
    _playerName = '';
    _selectedDifficulty = null;
    _showGameSetup = false;
    _selectedProfile = null;
    _chosenSymbol = null;
    notifyListeners();
  }

  GameDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return GameDifficulty.easy;
      case 'medium':
        return GameDifficulty.medium;
      case 'hard':
        return GameDifficulty.hard;
      default:
        return GameDifficulty.medium;
    }
  }

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
