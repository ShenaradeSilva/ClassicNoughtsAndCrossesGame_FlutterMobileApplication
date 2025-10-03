import 'package:flutter/material.dart';
import '../model/player_model.dart';

class ProfileCardField extends StatelessWidget {
  final TextEditingController nameController;
  final PlayerProfile? selectedProfile;
  final Function(PlayerProfile?) onProfileSelected;
  final VoidCallback onTapSelectProfile;

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