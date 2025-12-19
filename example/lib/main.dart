import 'package:fancy_slot_machine/fancy_slot_machine.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final List<String> participants = [
    'Ahmed Mohamed',
    'Sara Hassan',
    'Mohamed Ali',
    'Fatima Ibrahim',
    'Omar Mahmoud',
    'Layla Yousef',
    'Hamdy Haggag',
    'Zainab Khalid',
  ];

  String? winner;
  bool isSpinning = false;

  void _startLocalSpin() {
    setState(() {
      isSpinning = true;
      winner = null;
    });

    // Simulate getting a winner from an API after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          winner = (participants..shuffle()).first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Fancy Slot Machine Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Lucky Draw',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // The Slot Machine Widget
              FancySlotMachine<String>(
                items: participants,
                labelBuilder: (item) => item,
                onSpinStart: _startLocalSpin,
                onWinnerSelected: (selected) {
                  setState(() {
                    isSpinning = false;
                    winner = selected;
                  });
                  _showWinnerDialog(selected);
                },
                selectedWinner: winner,
                isSpinning: isSpinning,
                accentColor: const Color(0xFFFBBF24),
              ),

              const SizedBox(height: 50),

              if (!isSpinning)
                ElevatedButton(
                  onPressed: _startLocalSpin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Trigger Spin from Outside',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWinnerDialog(String winnerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Center(
          child: Text(
            '🎉 Congratulations! 🎉',
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Color(0xFFFBBF24), size: 64),
            const SizedBox(height: 16),
            Text(
              winnerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cool!',
              style: TextStyle(color: Color(0xFFFBBF24)),
            ),
          ),
        ],
      ),
    );
  }
}
