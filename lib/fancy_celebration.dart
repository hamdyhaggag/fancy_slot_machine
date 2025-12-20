import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:iconsax/iconsax.dart';

/// A premium celebration overlay for announcing winners.
class FancyCelebration {
  /// Shows the celebration dialog.
  static void show(
    BuildContext context, {
    required String winnerName,
    required int score,
    int? position,
    int? totalParticipants,
    VoidCallback? onClose,
    VoidCallback? onNext,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FancyCelebrationScreen(
            winnerName: winnerName,
            score: score,
            position: position ?? 1,
            totalParticipants: totalParticipants ?? 0,
            onClose: onClose,
            onNext: onNext,
            animation: animation,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _FancyCelebrationScreen extends StatefulWidget {
  final String winnerName;
  final int score;
  final int position;
  final int totalParticipants;
  final VoidCallback? onClose;
  final VoidCallback? onNext;
  final Animation<double> animation;

  const _FancyCelebrationScreen({
    required this.winnerName,
    required this.score,
    required this.position,
    required this.totalParticipants,
    this.onClose,
    this.onNext,
    required this.animation,
  });

  @override
  State<_FancyCelebrationScreen> createState() =>
      _FancyCelebrationScreenState();
}

class _FancyCelebrationScreenState extends State<_FancyCelebrationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color trophyColor;
    String positionEmoji;
    String positionText;

    if (widget.position == 1) {
      trophyColor = const Color(0xFFFFD700); // Pure Gold
      positionEmoji = '🥇';
      positionText = 'First Place';
    } else if (widget.position == 2) {
      trophyColor = const Color(0xFFE5E7EB); // Bright Silver
      positionEmoji = '🥈';
      positionText = 'Second Place';
    } else if (widget.position == 3) {
      trophyColor = const Color(0xFFCD7F32); // Deep Bronze
      positionEmoji = '🥉';
      positionText = 'Third Place';
    } else {
      trophyColor = Colors.blueAccent;
      positionEmoji = '✨';
      positionText = 'Winner #${widget.position}';
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Premium Animated Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A), // Deep Midnight
                  Color(0xFF1E293B), // Slate Dark
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          // 2. Subtle Mesh Gradient Effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(
                painter: _MeshGradientPainter(trophyColor),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top Decorations
                      FadeTransition(
                        opacity: widget.animation,
                        child: ScaleTransition(
                          scale: widget.animation,
                          child: Column(
                            children: [
                              _buildCelebrationBadge(
                                  positionEmoji, positionText, trophyColor),
                              const SizedBox(height: 40),
                              _buildAnimatedTrophy(trophyColor),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Winner Name Card
                      _buildWinnerCard(widget.animation, trophyColor),

                      const SizedBox(height: 40),

                      // Stats & Progress
                      if (widget.totalParticipants > 0)
                        _buildCelebrationStats(widget.animation,
                            widget.position, widget.totalParticipants),

                      const SizedBox(height: 60),

                      // Action Button
                      _buildActionButton(
                          context, trophyColor, widget.animation),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Confetti Sources
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: [trophyColor, Colors.white, Colors.blue, Colors.pink],
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationBadge(String emoji, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTrophy(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(Iconsax.cup, size: 100, color: color),
          ),
        );
      },
    );
  }

  Widget _buildWinnerCard(Animation<double> animation, Color trophyColor) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.winnerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.star5,
                        color: Color(0xFFFBBF24), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.score} Points',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFBBF24),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationStats(
      Animation<double> animation, int position, int total) {
    return FadeTransition(
      opacity: animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMiniStat(Iconsax.user_tick, '$position', 'Rank'),
          const SizedBox(width: 40),
          _buildMiniStat(Iconsax.people, '$total', 'Total'),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, Color color, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, Colors.white, 0.2)!],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _confettiController.stop();
            if (widget.onNext != null) {
              widget.onNext!();
            } else {
              Navigator.pop(context);
              widget.onClose?.call();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.onNext != null ? 'Continue' : 'Close',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                  widget.onNext != null
                      ? Iconsax.arrow_right_1
                      : Iconsax.close_circle,
                  color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  final Color baseColor;
  _MeshGradientPainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Draw some organic blobs
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      200,
      paint..color = baseColor.withValues(alpha: 0.2),
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.8),
      250,
      paint..color = Colors.blue.withValues(alpha: 0.1),
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      150,
      paint..color = Colors.purple.withValues(alpha: 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
