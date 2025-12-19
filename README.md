# Fancy Slot Machine

A premium, customizable Slot Machine / Drum widget for draws and winners selection in Flutter.

## Features

- Generic Type Support: Works with any data model.
- Integrated Spin Logic: Built-in "Spin" button and animation state management.
- Fully Customizable: Control colors, durations, text styles, and drum aesthetics.
- Smooth Physics: Uses ListWheelScrollView for a realistic 3D drum rotation effect.
- Remote Triggering: Control the winner and animation from external state.
- Responsive & Lightweight: Optimized for mobile performance.

## Installation

Add fancy_slot_machine to your pubspec.yaml:

```yaml
dependencies:
  fancy_slot_machine: ^0.0.1
  iconsax: ^0.0.8
```

## Usage

```dart
import 'package:fancy_slot_machine/fancy_slot_machine.dart';

FancySlotMachine<String>(
  items: ['Alice', 'Bob', 'Charlie'],
  labelBuilder: (item) => item,
  onSpinStart: () => print('Spinning!'),
  onWinnerSelected: (winner) => print('Winner: $winner'),
)
```

## API Reference

| Property | Type | Description |
| :--- | :--- | :--- |
| items | List<T> | The list of items to spin through. |
| labelBuilder | String Function(T) | How to extract the name. |
| onSpinStart | VoidCallback | Called when spin begins. |
| onWinnerSelected | Function(T) | Called when winner is picked. |
| selectedWinner | T? | Set this to target a winner. |
| isSpinning | bool | Control spinning state. |
| accentColor | Color | Primary theme color. |

## Developer

Developed by Hamdy Haggag.
- GitHub: @hamdyhaggag
- Portfolio: hamdyhaggag.netlify.app
