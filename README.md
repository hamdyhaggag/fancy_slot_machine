# 🎰 Fancy Slot Machine for Flutter

A **premium, highly customizable, and buttery-smooth** package for creating Live Draw and Slot Machine experiences in Flutter.

This package provides a complete "Live Draw" UI system, including:
*   🎰 **Premium Slot Machine**: A realistic 3D drum with smooth physics and elastic stops.
*   🎉 **Full-Screen Celebration**: A stunning winner announcement with confetti and trophy animations.
*   📊 **Draw Statistics**: A clean dashboard for displaying participants, drawn, and remaining counts.
*   🏆 **Recent Winners List**: A horizontal scrollable list of previously selected winners.
*   📝 **Draw Summary**: A beautiful card to display when the draw is fully completed.

---

## 📸 Visual Showcase

<div align="center">
  <p><i>Experience the smooth physics and luxury gold aesthetics in action.</i></p>
</div>

### Live Animation
<p align="center">
  <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/demo.gif" width="300" alt="Slot Machine Animation">
  <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/demo%202.gif" width="300" alt="Full Draw Flow">
</p>

### Screenshots
<p align="center">
  <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/preview.webp" width="250" alt="Main Screen">
  <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/preview2.webp" width="250" alt="Draw in Progress">
  <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/winner.webp" width="250" alt="Winner Celebration">
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#️-api-reference">API</a>
</p>

---

## Features

- **Generic Type Support**: Works with any data model.
- **Integrated Spin Logic**: Built-in "Spin" button and animation state management.
- **Full UI System**: Comes with celebration dialogs, stats bars, and winner lists.
- **Smooth Physics**: Uses ListWheelScrollView for a realistic 3D drum rotation effect.
- **Remote Triggering**: Control the winner and animation from external state.
- **Responsive & Lightweight**: Optimized for mobile performance.

---

## Installation

Add fancy_slot_machine to your pubspec.yaml:

```yaml
dependencies:
  fancy_slot_machine: ^0.0.5
  iconsax: ^0.0.8
  confetti: ^0.8.0
```

---

## Usage

### 1. Basic Slot Machine
```dart
import 'package:fancy_slot_machine/fancy_slot_machine.dart';

FancySlotMachine<String>(
  items: ['Alice', 'Bob', 'Charlie'],
  labelBuilder: (item) => item,
  onSpinStart: () => print('Spinning!'),
  onWinnerSelected: (winner) => print('Winner: $winner'),
)
```

### 2. Full Live Draw Experience

```dart
// 1. Show Stats Header
FancyDrawStats(
  participantsCount: 100,
  drawnCount: 5,
  remainingCount: 95,
);

// 2. Main Slot Machine
FancySlotMachine<String>(
  items: participants,
  labelBuilder: (item) => item,
  onWinnerSelected: (winner) {
    // 3. Trigger Celebration on Win
    FancyCelebration.show(
      context,
      winnerName: winner,
      score: 1000,
      onNext: () => Navigator.pop(context),
    );
  },
);

// 4. Show Recent Winners
FancyRecentWinners(
  winners: myWinnersList, // List of FancyWinnerItem
);
```

---

## API Reference

### FancySlotMachine

| Property | Type | Description |
| :--- | :--- | :--- |
| items | List<T> | The list of items to spin through. |
| labelBuilder | String Function(T) | How to extract the name. |
| onSpinStart | VoidCallback | Called when spin begins. |
| onWinnerSelected | Function(T) | Called when winner is picked. |
| selectedWinner | T? | Set this to target a winner. |
| isSpinning | bool | Control spinning state. |
| accentColor | Color | Primary theme color. |

### FancyCelebration

| Method | Description |
| :--- | :--- |
| **show(context, ...)** | Static method to trigger the full-screen celebration overlay. |

---

## Developer

Developed by Hamdy Haggag.
- GitHub: @hamdyhaggag
- Portfolio: hamdyhaggag.netlify.app
