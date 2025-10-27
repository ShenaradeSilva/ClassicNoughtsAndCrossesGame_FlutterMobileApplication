# Classic Noughts & Crosses (Tic Tac Toe)

A mobile implementation of the classic Noughts & Crosses (Tic Tac Toe) game developed in **Flutter** and **Dart**. Users play against an AI opponent with multiple difficulty levels, undo functionality, and persistent score tracking.

---

## Table of Contents

- [Demo](#demo)  
- [Features](#features)  
- [Game Rules](#game-rules)  
- [Architecture & Code Structure](#architecture--code-structure)  
- [Installation](#installation)  
- [Dependencies](#dependencies)  
- [Unit Testing](#unit-testing)  
- [License](#license)  

---

## Demo

- Human player can play against AI (Easy, Medium, Hard).  
- Players can select a profile image and enter a name.  
- Game outcome is displayed with persistent scoring across sessions.  
- Undo last move rewinds the turn (player + AI).  
- Restart game resets the board for a new session.

---

## Features

| Feature                   | Description                                                               |
|---------------------------|---------------------------------------------------------------------------|
| Player Name & Profile     | Enter a name and select a profile image (male/female/none).               |
| Difficulty Levels         | Easy: random moves                                                        |
|                           | Medium: alternating random/strategic moves                                |
|                           | Hard: strategic AI (win/block/fork/center/corner/side).                   |
| Undo Move                 | Rewinds last move (player + AI).                                          |
| Restart Game              | Clears board and resets game state.                                       |
| Win/Loss/Draw Detection   | Automatically detects game outcomes.                                      |
| Persistent Scoring        | Tracks wins, losses, and draws across sessions using `SharedPreferences`. |
| AI-first Option           | AI can start the game to provide a different challenge.                   |

---

## Game Rules

- A player wins by placing three marks (X or O) in a line: horizontally, vertically, or diagonally.  
- If all 9 cells are filled without a winner, the game ends in a draw.  

**Hard Mode AI Strategy (Pseudocode):**  
1. Win/block two-in-a-row.  
2. Create a fork if possible.  
3. Take center if free.  
4. Play opposite corner if opponent occupies a corner.  
5. Take any free corner.  
6. Take any empty side.

---

## Architecture & Code Structure

The app follows the **MVVM (Model-View-ViewModel)** pattern:
```
    lib/
    ├── model/                # Game, Player, Stats data structures
    ├── view/                 # UI screens: Home, Game, Stats
    ├── view_model/           # Business logic & state management
    ├── widgets/              # Reusable UI components (cards, profile selectors)
    test/
    ├── unit_test.dart        # Unit tests for game logic
    assets/
    ├── male.png
    ├── female.png
    └── ai.png
    pubspec.yaml              # Dependencies and assets
```

**Key Components:**

- **GameViewModel:** Manages game state, moves, AI behavior, undo/reset.  
- **AIService:** Determines AI moves for all difficulty levels.  
- **StatsViewModel:** Stores and retrieves persistent win/loss/draw statistics.  
- **Widgets:** `PlayerCard`, `ProfileCardField` for UI rendering.

---

## Installation

1. Clone the repository:

        git clone <repository-url>


2. Navigate to the project folder:

        cd classic_noughts_and_crosses_game


3. Fetch dependencies:

        flutter pub get


4. Run the app:

        flutter run


---

## Dependencies

- provider: State management for reactive UI.
- shared_preferences: Persistent storage for player statistics.
- flutter_test: Unit testing framework.

---

## Unit Testing

Unit tests verify core functionality:
- Valid/invalid moves (makeMove / isValidMove)
- Win/Loss/Draw detection (checkWinner)
- Undo functionality (undoMove)
- AI behavior (Easy, Hard)

---

## Run tests:

     test/unit_test.dart


All tests are passing, ensuring the game logic behaves as expected.


---
