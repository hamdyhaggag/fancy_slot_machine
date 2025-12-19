# Fancy Slot Machine Documentation

Welcome to the official documentation for the **Fancy Slot Machine** Flutter widget. This guide provides deep-dive information into how the widget works, how to extend it, and best practices for implementation.

## 📖 Table of Contents
1. [Introduction](#introduction)
2. [Architecture](#architecture)
3. [Component Structure](#component-structure)
4. [Customization Guide](#customization-guide)
5. [Performance Optimization](#performance-optimization)
6. [Troubleshooting](#troubleshooting)

---

## 1. Introduction
The `FancySlotMachine` is a specialized widget built to simulate the physical mechanics of a slot machine drum. Unlike standard lists, it uses a cylindrical projection to give depth and realistic motion to the items being scrolled.

### Core Philosophy
- **Immersiveness**: The UI should feel alive and tactile.
- **Simplicity**: Complex animation logic should be hidden behind a simple API.
- **Flexibility**: The developer should be able to pass any data type through the machine.

---

## 2. Architecture
The widget is built as a `StatefulWidget` to manage the animation timers and scroll controllers internally.

### Scroll Mechanism
At its heart, it uses `ListWheelScrollView.useDelegate`.
- **`FixedExtentScrollController`**: Used to programmatically jump or animate to specific indices.
- **Infinite Scrolling**: Realized by using a `null` childCount in the delegate and using the modulo operator (`index % items.length`) to loop the data.

### Animation Phases
1. **Spinning Phase**: A `Timer.periodic` triggers `animateToItem` every 100ms with a linear curve, creating a continuous fast-blur motion.
2. **Slowing Down (Suspense) Phase**: Triggered when a `selectedWinner` is provided. The timer is cancelled, and a single `animateToItem` call is made with an `elasticOut` curve and a longer duration.

---

## 3. Component Structure
The widget is composed of several layers in a `Stack`:
- **Background Drum**: A `Container` with a dark gradient and depth-defining shadows.
- **Shader Mask**: Applied on top of the scroll view to fade out items at the top and bottom borders.
- **Selection Frame**: A high-lighted border in the center indicating the "Winning Area".
- **Indicators**: Animated arrows focusing the eye on the selection frame.
- **Spin Button**: A floating action button integrated into the bottom of the drum for one-touch interaction.

---

## 4. Customization Guide

### Changing Themes
You can match the machine to your app's brand by tweaking the `accentColor` and `drumColor`.

```dart
FancySlotMachine(
  accentColor: Color(0xFF00FF00), // Neon Green
  drumColor: Color(0xFF1A1A1A),  // Deep Grey
  textColor: Colors.white70,
  // ...
)
```

### Adjusting Suspense
The `stopDuration` property controls how long the "slowing down" part takes. For high-stakes draws, a longer duration (e.g., 6-8 seconds) increases the tension.

```dart
stopDuration: Duration(seconds: 7),
```

### Custom Data Display
Use `labelBuilder` for the main name and `subtitleBuilder` for metadata (like ID, points, or location).

---

## 5. Performance Optimization
To ensure 60/120 FPS performance:
- **Image Items**: If your items include images, pre-cache them before starting the spin.
- **List Size**: While the widget handles large lists, try to keep the `items` list under 1000 for the smoothest memory management.
- **Repaint Boundaries**: The widget uses internal optimizations, but ensure the parent doesn't rebuild unnecessarily during the spin.

---

## 6. Troubleshooting

### Why is the winner not landing correctly?
Ensure that the `selectedWinner` you pass is either the exact same instance as one of the items in the `items` list, or that your `labelBuilder` returns a unique string for that item. The matching logic first tries direct reference, then falls back to label comparison.

### Overflow errors?
The widget has a fixed height of 300px. Ensure it's placed in a container that can accommodate this height, or wrap it in a `Center` / `SizedBox`.

---

Developed by **Hamdy Haggag**
[Explore the Code](https://github.com/hamdyhaggag/fancy_slot_machine)
