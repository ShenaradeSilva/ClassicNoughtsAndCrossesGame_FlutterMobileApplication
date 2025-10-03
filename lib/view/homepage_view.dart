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
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    context.read<HomepageViewModel>().setPlayerName(_nameController.text);
  }

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
            // None option
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
                    Icon(Icons.clear, color: Colors.white, size: 50),
                    SizedBox(height: 8),
                    Text('None', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

            // Profile options (exclude AI)
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

    if (chosenSymbol != null) {
      viewModel.setChosenSymbol(chosenSymbol);
      _navigateToGame(context);
    }
  }

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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      viewModel.resetForm();
                      _nameController.clear();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
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

                  if (viewModel.showGameSetup) ...[
                    ProfileCardField(
                      nameController: _nameController,
                      selectedProfile: viewModel.selectedProfile,
                      onProfileSelected: (profile) =>
                          viewModel.setSelectedProfile(profile),
                      onTapSelectProfile: () => _selectProfileCard(context),
                    ),
                    const SizedBox(height: 10),

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
                          DropdownMenuItem(value: 'easy', child: Text('Easy')),
                          DropdownMenuItem(
                              value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'hard', child: Text('Hard')),
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