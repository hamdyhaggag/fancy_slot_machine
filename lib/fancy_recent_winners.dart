import 'package:flutter/material.dart';
import 'fancy_models.dart';

/// A widget to display a horizontal list of recent winners.
class FancyRecentWinners extends StatelessWidget {
  final List<FancyWinnerItem> winners;
  final Color primaryColor;

  const FancyRecentWinners({
    super.key,
    required this.winners,
    this.primaryColor = const Color(0xFFFBBF24),
  });

  @override
  Widget build(BuildContext context) {
    if (winners.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        itemCount: winners.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final winner = winners[index];
          String name = _getDoubleName(winner.name);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: primaryColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(color: Color(0xFF2D3748), fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getDoubleName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return "Winner";
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    return parts[0];
  }
}
