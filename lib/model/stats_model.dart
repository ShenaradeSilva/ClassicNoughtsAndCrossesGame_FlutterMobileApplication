/*
  file: stats_model.dart
  functionality:
    Manages player statistics for the Noughts and Crosses game.
    Provides methods to load, save, update, and reset stats for individual users as well as for all users.
    Stores data persistently using SharedPreferences.
    Includes:
      - wins: Number of wins.
      - losses: Number of losses.
      - draws: Number of draws.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 27/09/2025
*/

import 'package:shared_preferences/shared_preferences.dart';

// Represents the game statistics for a single user.
class StatsModel {
  int wins;
  int losses;
  int draws;

  StatsModel({this.wins = 0, this.losses = 0, this.draws = 0});

  // Load stats for a specific user
  static Future<StatsModel> load(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return StatsModel(
      wins: prefs.getInt('${userName}_wins') ?? 0,
      losses: prefs.getInt('${userName}_losses') ?? 0,
      draws: prefs.getInt('${userName}_draws') ?? 0,
    );
  }

  // Save stats for a specific user
  Future<void> save(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${userName}_wins', wins);
    await prefs.setInt('${userName}_losses', losses);
    await prefs.setInt('${userName}_draws', draws);
  }

  // Increment stats for a specific user
  Future<void> update({
    required String userName,
    int win = 0,
    int loss = 0,
    int draw = 0,
  }) async {
    wins += win;
    losses += loss;
    draws += draw;
    await save(userName);
  }

  // Reset stats for a specific user
  Future<void> reset(String userName) async {
    wins = 0;
    losses = 0;
    draws = 0;
    await save(userName);
  }

  // Load stats for all users
  static Future<Map<String, StatsModel>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, StatsModel> allStats = {};

    // Detect all usernames by keys ending with _wins, _losses, or _draws
    final keys = prefs.getKeys();
    final usernames = <String>{};
    for (var key in keys) {
      if (key.endsWith('_wins') || key.endsWith('_losses') || key.endsWith('_draws')) {
        usernames.add(key.replaceAll(RegExp(r'_(wins|losses|draws)$'), ''));
      }
    }

    // Load each user's stats
    for (var user in usernames) {
      allStats[user] = await load(user);
    }

    return allStats;
  }

  // Save stats for all users
  static Future<void> saveAll(Map<String, StatsModel> allStats) async {
    for (var entry in allStats.entries) {
      await entry.value.save(entry.key);
    }
  }
}
