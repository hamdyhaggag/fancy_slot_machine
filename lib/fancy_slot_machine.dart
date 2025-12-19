import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// A premium, customizable Slot Machine / Drum widget for draws and winners selection.
/// This widget is designed to be extracted as a package.
class FancySlotMachine<T> extends StatefulWidget {
  /// The list of items to spin through.
  final List<T> items;

  /// Function to extract the display name from the item.
  final String Function(T) labelBuilder;

  /// Function to extract the subtitle/score from the item.
  final String Function(T)? subtitleBuilder;

  /// Callback when the spin starts.
  final VoidCallback onSpinStart;

  /// Callback when the animation completes and lands on a winner.
  final Function(T) onWinnerSelected;

  /// The duration of the slowing down animation.
  final Duration stopDuration;

  /// The color of the winning frame and indicators.
  final Color accentColor;

  /// The color of the text inside the slot.
  final Color textColor;

  /// The background color of the drum.
  final Color drumColor;

  /// An external trigger or state to tell the machine who the winner is.
  /// When this value changes, the machine will start slowing down to land on it.
  final T? selectedWinner;

  /// Whether the machine is currently in the "spinning" state.
  final bool isSpinning;

  const FancySlotMachine({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.subtitleBuilder,
    required this.onSpinStart,
    required this.onWinnerSelected,
    this.selectedWinner,
    this.isSpinning = false,
    this.stopDuration = const Duration(seconds: 4),
    this.accentColor = const Color(0xFFFBBF24),
    this.textColor = Colors.white,
    this.drumColor = const Color(0x33000000),
  });

  @override
  State<FancySlotMachine<T>> createState() => _FancySlotMachineState<T>();
}

class _FancySlotMachineState<T> extends State<FancySlotMachine<T>> {
  late FixedExtentScrollController _controller;
  Timer? _spinTimer;
  bool _internalIsSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
    _internalIsSpinning = widget.isSpinning;
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(FancySlotMachine<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If a winner is provided and we were spinning, stop on it
    if (widget.selectedWinner != null &&
        oldWidget.selectedWinner == null &&
        _internalIsSpinning) {
      _stopSpinning(widget.selectedWinner!);
    }

    // Sync internal spinning state if forced from outside
    if (widget.isSpinning != oldWidget.isSpinning) {
      if (widget.isSpinning && !_internalIsSpinning) {
        _startSpinning();
      } else if (!widget.isSpinning && _internalIsSpinning) {
        _internalIsSpinning = false;
        _spinTimer?.cancel();
      }
    }
  }

  void _startSpinning() {
    if (_internalIsSpinning || widget.items.isEmpty) return;

    setState(() {
      _internalIsSpinning = true;
    });

    widget.onSpinStart();

    const duration = Duration(milliseconds: 100);
    _spinTimer = Timer.periodic(duration, (timer) {
      if (!_internalIsSpinning) {
        timer.cancel();
        return;
      }
      if (_controller.hasClients) {
        int current = _controller.selectedItem;
        _controller.animateToItem(
          current + 5,
          duration: duration,
          curve: Curves.linear,
        );
      }
    });
  }

  void _stopSpinning(T winner) {
    _spinTimer?.cancel();

    if (widget.items.isEmpty) return;

    // Find index of winner
    int winnerIndex = widget.items.indexOf(winner);

    if (winnerIndex == -1) {
      // Fallback: try matching by label if direct reference fails
      winnerIndex = widget.items.indexWhere(
          (item) => widget.labelBuilder(item) == widget.labelBuilder(winner));
    }

    if (winnerIndex == -1) winnerIndex = 0;

    int currentItem = _controller.selectedItem;
    int itemsCount = widget.items.length;

    int relativeCurrent = currentItem % itemsCount;
    int diff = winnerIndex - relativeCurrent;
    if (diff <= 0) diff += itemsCount;

    // Add exactly 2 full rotations for suspense then land
    int targetItem = currentItem + diff + (itemsCount * 2);

    _controller
        .animateToItem(
      targetItem,
      duration: widget.stopDuration,
      curve: Curves.elasticOut,
    )
        .then((_) {
      if (mounted) {
        setState(() {
          _internalIsSpinning = false;
        });
        widget.onWinnerSelected(winner);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // The Drum
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: widget.drumColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                  Colors.transparent
                ],
                stops: [0.0, 0.2, 0.8, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              itemExtent: 80,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.005,
              squeeze: 1.1,
              diameterRatio: 1.5,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final dataIndex = index % widget.items.length;
                  final item = widget.items[dataIndex];
                  return _buildItemRow(item);
                },
                childCount: null,
              ),
            ),
          ),
        ),

        // Selection Frame
        IgnorePointer(
          child: Container(
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: widget.accentColor, width: 2),
              borderRadius: BorderRadius.circular(16),
              color: widget.accentColor.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ],
            ),
          ),
        ),

        // Indicators
        Positioned(
          left: 10,
          child:
              Icon(Iconsax.arrow_right_1, color: widget.accentColor, size: 32),
        ),
        Positioned(
          right: 10,
          child:
              Icon(Iconsax.arrow_left_1, color: widget.accentColor, size: 32),
        ),

        // Spin Button (Integrated)
        Positioned(
          bottom: 0,
          child: _internalIsSpinning
              ? const SizedBox()
              : GestureDetector(
                  onTap: _startSpinning,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE94560),
                          const Color(0xFFE94560).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE94560).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Text(
                      'Draw Winner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildItemRow(T item) {
    final label = widget.labelBuilder(item);
    final subtitle = widget.subtitleBuilder?.call(item);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user,
                color: widget.textColor.withOpacity(0.7), size: 20),
            const SizedBox(width: 12),
            Text(
              _formatName(label),
              style: TextStyle(
                color: widget.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatName(String fullName) {
    if (fullName.trim().isEmpty) return "";
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    return parts[0];
  }
}
