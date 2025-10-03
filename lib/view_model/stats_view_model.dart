import 'package:flutter/material.dart';
import '../model/stats_model.dart';
import '../model/player_model.dart';

class StatsViewModel extends ChangeNotifier {
  final Map<String, StatsModel> _allStats = {}; // store stats per player

  // Last game info (to show on ResultsScreen)
  PlayerProfile? lastUserProfile;
  String lastUserName = '';
  Player lastUserSymbol = Player.x;

  PlayerProfile? lastAIProfile;
  String lastAIName = 'AI';
  Player lastAISymbol = Player.o;

  /// true = user won, false = AI won, null = draw
  bool? lastResult;

  StatsModel get currentStats =>
      _allStats[lastUserName] ?? StatsModel(wins: 0, losses: 0, draws: 0);

  int get wins => currentStats.wins;
  int get losses => currentStats.losses;
  int get draws => currentStats.draws;

  StatsViewModel();

  /// Ensure stats are loaded for a specific user
  Future<void> ensureLoaded(String userName) async {
    if (!_allStats.containsKey(userName)) {
      final all = await StatsModel.loadAll(); // load all persisted stats
      _allStats.addAll(all);

      // If user has no previous stats, create default
      if (!_allStats.containsKey(userName)) {
        _allStats[userName] = StatsModel(wins: 0, losses: 0, draws: 0);
      }
    }
  }

  StatsModel _getOrCreateStats(String userName) {
    if (!_allStats.containsKey(userName)) {
      _allStats[userName] = StatsModel(wins: 0, losses: 0, draws: 0);
    }
    return _allStats[userName]!;
  }

  /// Record a win
  Future<void> addWin({
    required String userName,
    PlayerProfile? profile,
    required Player userSymbol,
  }) async {
    lastResult = true;
    _setLastGame(userName, profile, userSymbol, lastResult);

    final stats = _getOrCreateStats(userName);
    stats.wins++;
    await StatsModel.saveAll(_allStats);
    notifyListeners();
  }

  /// Record a loss
  Future<void> addLoss({
    required String userName,
    PlayerProfile? profile,
    required Player userSymbol,
  }) async {
    lastResult = false;
    _setLastGame(userName, profile, userSymbol, lastResult);

    final stats = _getOrCreateStats(userName);
    stats.losses++;
    await StatsModel.saveAll(_allStats);
    notifyListeners();
  }

  /// Record a draw
  Future<void> addDraw({
    required String userName,
    PlayerProfile? profile,
    required Player userSymbol,
  }) async {
    lastResult = null;
    _setLastGame(userName, profile, userSymbol, lastResult);

    final stats = _getOrCreateStats(userName);
    stats.draws++;
    await StatsModel.saveAll(_allStats);
    notifyListeners();
  }

  void _setLastGame(
      String userName, PlayerProfile? profile, Player userSymbol, bool? result) {
    lastUserName = userName;
    lastUserProfile = profile;
    lastUserSymbol = userSymbol;

    lastAIName = 'AI';
    lastAIProfile = PlayerProfile.ai;
    lastAISymbol = userSymbol == Player.x ? Player.o : Player.x;
  }

  /// Reset stats for a specific player
  Future<void> resetStats(String userName) async {
    lastResult = null;
    lastUserName = '';
    lastUserProfile = null;
    lastAIProfile = null;

    _allStats[userName] = StatsModel(wins: 0, losses: 0, draws: 0);
    await StatsModel.saveAll(_allStats);
    notifyListeners();
  }
}
