/*
  file: profile_card_field.dart
  functionality:
    Allows the user to input their name and select a profile avatar (male or female). 
    It displays a styled text field alongside a circular avatar preview that can be tapped to choose a profile.
    Features:
      - Text input field with custom border and label styling.
      - Selectable avatar image (male/female) with fallback icon.
      - Responsive layout using Row and Expanded for alignment.
  author: Hettiarachchige Mary Shenara Amodini DE SILVA (10686404)
  date created: 20/09/2025
*/

import 'package:flutter/material.dart';
import '../model/player_model.dart';

// A widget that combines a player's name input field with a selectable profile avatar (male/female) for user customization.
class ProfileCardField extends StatelessWidget {
  final TextEditingController nameController;         // Controller for the player name text field.
  final PlayerProfile? selectedProfile;               // Currently selected player profile (male/female), can be null.
  final Function(PlayerProfile?) onProfileSelected;   // Callback when a profile is selected from available options.
  final VoidCallback onTapSelectProfile;              // Callback triggered when the profile selection icon is tapped.

  // Mapping between player profiles and their respective image assets.
  final Map<PlayerProfile, String> profileImages = {
    PlayerProfile.male: 'assets/male.png',
    PlayerProfile.female: 'assets/female.png',
  };

  ProfileCardField({
    super.key,
    required this.nameController,
    required this.selectedProfile,
    required this.onProfileSelected,
    required this.onTapSelectProfile,
  });

  // Builds the combined name input and avatar selection UI.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter your name',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              GestureDetector(
                onTap: onTapSelectProfile,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                    image: selectedProfile != null
                        ? DecorationImage(
                            image: AssetImage(profileImages[selectedProfile!]!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: selectedProfile == null ? Colors.white : null,
                  ),
                  child: selectedProfile == null
                      ? const Icon(Icons.person_outline, color: Colors.purple)
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select Card',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}