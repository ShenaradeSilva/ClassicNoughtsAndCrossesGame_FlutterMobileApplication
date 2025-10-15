/*
  file: homepage_view.dart
  functionality:
    This file defines the HomepageView for the Tic Tac Toe game. 
    It provides the user interface for starting a new game, selecting player profile, choosing difficulty, 
    and selecting a symbol (X or O). 
    It leverages the Provider package for state management via HomepageViewModel and navigates to 
    GameView upon starting the game.
    Includes:
      - Input player name
      - Select player profile (male, female, none)
      - Choose difficulty (easy, medium, hard)
      - Select player symbol (X/O)
      - Navigate to GameView with configured game settings
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 20/09/2025
*/

import 'package:classic_noughts_and_crosses_game/view_model/game_view_model.dart';
import 'package:classic_noughts_and_crosses_game/widgets/instructions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/homepage_view_model.dart';
import '../model/player_model.dart';
import '../widgets/logo.dart';
import '../widgets/profile_card_field.dart';
import 'game_view.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final TextEditingController _nameController = TextEditingController();    // Controller for the player's name input field

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);      // Listen to changes in the name field and update the ViewModel
  }

  // Updates the player's name in the HomepageViewModel
  void _onNameChanged() {
    context.read<HomepageViewModel>().setPlayerName(_nameController.text);
  }

  // Shows the profile selection modal bottom sheet
  void _selectProfileCard(BuildContext context) {
    final viewModel = context.read<HomepageViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // None option for no profile selection
            GestureDetector(
              onTap: () {
                viewModel.setSelectedProfile(null);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: viewModel.selectedProfile == null
                        ? Colors.purpleAccent
                        : Colors.transparent,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.clear, 
                      color: Colors.white, 
                      size: 50
                    ),
                    SizedBox(height: 8),
                    Text(
                      'None', 
                      style: TextStyle(color: Colors.white)
                    ),
                  ],
                ),
              ),
            ),

            // Dynamic list of profiles (male/female)
            ...PlayerProfile.values
                .where((p) => p != PlayerProfile.ai)
                .map((profile) {
              final isSelected = viewModel.selectedProfile == profile;
              return GestureDetector(
                onTap: () {
                  viewModel.setSelectedProfile(profile);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.purpleAccent : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        profile == PlayerProfile.male
                            ? 'assets/male.png'
                            : 'assets/female.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.name.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Displays a dialog for the user to choose X or O
  Future<void> _showSymbolSelectionDialog(BuildContext context) async {
    final viewModel = context.read<HomepageViewModel>();

    Player? chosenSymbol = await showDialog<Player>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.purple[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose your symbol',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                    ),
                    onPressed: () => Navigator.pop(context, Player.x),
                    child: const Text('X'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                    ),
                    onPressed: () => Navigator.pop(context, Player.o),
                    child: const Text('O'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // If a symbol is chosen, update ViewModel and navigate to game
    if (chosenSymbol != null) {
      viewModel.setChosenSymbol(chosenSymbol);
      _navigateToGame(context);
    }
  }

  // Navigates to GameView with the selected game configuration
  void _navigateToGame(BuildContext context) {
    final viewModel = context.read<HomepageViewModel>();
    final config = viewModel.getGameConfig();

    if (config != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => GameViewModel(gameConfig: config),
            child: const GameView(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: viewModel.showGameSetup
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back, 
                      color: Colors.white
                    ),
                    onPressed: () {
                      viewModel.resetForm();
                      _nameController.clear();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline, 
                        color: Colors.white
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstructionsView()),
                        );
                      },
                    ),
                  ],
                )
              : null,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tic Tac Toe Game',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const TicTacToeLogo(),
                  const SizedBox(height: 40),

                  // Show initial buttons if not in setup mode
                  if (!viewModel.showGameSetup) ...[
                    ElevatedButton(
                      onPressed: () => viewModel.setShowGameSetup(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstructionsView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'How to Play',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],

                  // Game setup UI
                  if (viewModel.showGameSetup) ...[
                    ProfileCardField(
                      nameController: _nameController,
                      selectedProfile: viewModel.selectedProfile,
                      onProfileSelected: (profile) =>
                          viewModel.setSelectedProfile(profile),
                      onTapSelectProfile: () => _selectProfileCard(context),
                    ),
                    const SizedBox(height: 10),

                    // Difficulty selection dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: DropdownButtonFormField<String>(
                        value: viewModel.selectedDifficulty,
                        dropdownColor: Colors.purple[700],
                        decoration: InputDecoration(
                          labelText: 'Select Difficulty',
                          labelStyle: const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'easy', 
                            child: Text('Easy')
                          ),
                          DropdownMenuItem(
                            value: 'medium', 
                            child: Text('Medium')
                          ),
                          DropdownMenuItem(
                            value: 'hard', 
                            child: Text('Hard')
                          ),
                        ],
                        onChanged: (value) =>
                            viewModel.setSelectedDifficulty(value),
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        iconSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Start game button
                    ElevatedButton(
                      onPressed: () {
                        if (!viewModel.isFormValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter name and select difficulty!',
                              ),
                            ),
                          );
                          return;
                        }
                        _showSymbolSelectionDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Game',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}