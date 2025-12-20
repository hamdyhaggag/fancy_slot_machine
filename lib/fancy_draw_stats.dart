import 'package:flutter/material.dart';

/// A widget to display statistics for the draw.
class FancyDrawStats extends StatelessWidget {
  final String participantsLabel;
  final String drawnLabel;
  final String remainingLabel;
  final int participantsCount;
  final int drawnCount;
  final int remainingCount;
  final Color primaryColor;

  const FancyDrawStats({
    super.key,
    this.participantsLabel = 'Participants',
    this.drawnLabel = 'Drawn',
    this.remainingLabel = 'Remaining',
    required this.participantsCount,
    required this.drawnCount,
    required this.remainingCount,
    this.primaryColor = const Color(0xFFFBBF24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
                child: _buildStatItem(participantsLabel, '$participantsCount')),
            const VerticalDivider(color: Colors.grey),
            Expanded(child: _buildStatItem(drawnLabel, '$drawnCount')),
            const VerticalDivider(color: Colors.grey),
            Expanded(child: _buildStatItem(remainingLabel, '$remainingCount')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF718096),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
