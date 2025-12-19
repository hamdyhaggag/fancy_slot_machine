# 🎰 Fancy Slot Machine for Flutter

A **premium, highly customizable, and buttery-smooth** Slot Machine / Drum widget for Flutter.

---

## 📸 Visual Showcase

<div align="center">
  <p><i>Experience the smooth physics and luxury gold aesthetics in action.</i></p>
</div>

<table align="center">
  <tr>
    <td align="center" width="350">
      <b>Live Animation</b><br>
      <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/demo.gif" width="320" style="border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); border: 2px solid #333;">
    </td>
    <td align="center" width="300">
      <b>Modern UI</b><br>
      <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/preview.jpg" width="280" style="border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
    </td>
    <td align="center" width="300">
      <b>Winner Celebration</b><br>
      <img src="https://raw.githubusercontent.com/hamdyhaggag/fancy_slot_machine/master/assets/screenshots/winner.jpg" width="280" style="border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
    </td>
  </tr>
</table>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#🏆-why-choose-fancy-slot-machine">Why Us?</a> •
  <a href="#🚀-getting-started">Getting Started</a> •
  <a href="#⚙️-api-reference">API</a>
</p>

---

## Features

- Generic Type Support: Works with any data model.
- Integrated Spin Logic: Built-in "Spin" button and animation state management.
- Fully Customizable: Control colors, durations, text styles, and drum aesthetics.
- Smooth Physics: Uses ListWheelScrollView for a realistic 3D drum rotation effect.
- Remote Triggering: Control the winner and animation from external state.
- Responsive & Lightweight: Optimized for mobile performance.

---

## Why Fancy Slot Machine?

### Competitive Edge
Unlike basic carousel or slot widgets, this package focus on **Visual Trust**. When users see a high-fidelity animation and premium design, they perceive the drawing process as more credible and professional.

### Technical Superiority
1. **Lazy Loading**: Using `childDelegate`, only items currently in view are rendered, saving memory and CPU cycles.
2. **Deterministic Mechanics**: The stopping algorithm calculates the exact offset needed for multiple full rotations before landing, ensuring a perfect "suspense" phase.

---

### Comparison: Fancy Slot Machine vs. Others

| Feature | Standard Packages | Fancy Slot Machine 🚀 |
| :--- | :--- | :--- |
| **Visual Aesthetics** | Flat colors, outdated design. | **Modern Luxury Design** (Gold gradients, glassmorphism, professional shadows). |
| **Animation Physics** | Linear or abrupt stopping. | **Elastic Bouncy Physics** (Realistic inertia and "bounce" when landing). |
| **Data Interaction** | Often requires manual widget mapping. | **Generic Data Builders** (Pass your Model directly, it handles the rest). |
| **Customization** | Complex setup for frames/indicators. | **Plug & Play UI** (Pre-styled frame, indicators, and integrated spin button). |
| **Performance** | Laggy infinite scrolls. | **Seamless Infinite Loop** (High performance via `Delegates` handles 10,000+ items). |
| **Best For** | Simple mini-games. | **Premium Apps & Official Draws** (Admin panels, high-stakes competitions). |

### Key Value Pillars
- **Zero Setup Time**: Don't waste hours designing the drum. Just pass your list and `labelBuilder` and enjoy the magic.
- **High Performance**: Built with `ListWheelScrollView.useDelegate` ensuring 60/120 FPS even with massive datasets.
- **Visual Trust**: The premium aesthetic builds trust with participants, making the draw feel official and fair.

---

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
