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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Color(0xFF2D3748)),
          titleTextStyle: TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
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
  // Mock Data
  final List<String> participants = [
    'Ahmed Mohamed',
    'Sara Hassan',
    'Mohamed Ali',
    'Fatima Ibrahim',
    'Omar Mahmoud',
    'Layla Yousef',
    'Hamdy Haggag',
    'Zainab Khalid',
    'Youssef Ahmed',
    'Noura Salem',
  ];

  List<FancyWinnerItem> winners = [];
  String? currentTargetWinner;
  bool isSpinning = false;
  final int totalWinnersNeeded = 3;

  void _startSpin() {
    if (winners.length >= totalWinnersNeeded) return;

    setState(() {
      isSpinning = true;
      currentTargetWinner = null;
    });

    // Simulate network delay to pick a winner
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Pick a random winner who isn't already a winner
        final available = participants
            .where((p) => !winners.any((w) => w.name == p))
            .toList();
        if (available.isNotEmpty) {
          setState(() {
            currentTargetWinner = (available..shuffle()).first;
          });
        }
      }
    });
  }

  void _handleWinnerSelected(String winnerName) {
    setState(() {
      isSpinning = false;
      winners.add(FancyWinnerItem(
        name: winnerName,
        score: '${1000 + (winners.length * 150)}', // Mock score
        avatarUrl: null,
      ));
    });

    // Show the premium celebration dialog
    FancyCelebration.show(
      context,
      winnerName: winnerName,
      score: 1000 + (winners.length * 150),
      position: winners.length,
      totalParticipants: participants.length,
      onNext: () {
        Navigator.pop(context); // Close celebration
        // Optionally auto-start next spin or just wait
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = winners.length >= totalWinnersNeeded;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Draw'),
        centerTitle: true,
      ),
      body: isCompleted
          ? FancyDrawSummary(
              winners: winners,
              title: "Draw Completed!",
              subtitlePrefix: "Winners Selected:",
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. Stats Header
                  FancyDrawStats(
                    participantsCount: participants.length,
                    drawnCount: winners.length,
                    remainingCount: totalWinnersNeeded - winners.length,
                    participantsLabel: "Participants",
                    drawnLabel: "Drawn",
                    remainingLabel: "Remaining",
                  ),

                  const Spacer(),

                  // 2. Main Slot Machine
                  SizedBox(
                    height: 400,
                    child: FancySlotMachine<String>(
                      items: participants,
                      labelBuilder: (item) => item,
                      subtitleBuilder: (item) => '1000 Points', // Mock points
                      isSpinning: isSpinning,
                      selectedWinner: currentTargetWinner,
                      onSpinStart:
                          _startSpin, // Triggered by button in slot machine
                      onWinnerSelected: _handleWinnerSelected,
                      accentColor: const Color(0xFFFBBF24),
                    ),
                  ),

                  const Spacer(),

                  // 3. Recent Winners List
                  if (winners.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: Text(
                          "Recent Winners",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    FancyRecentWinners(winners: winners.reversed.toList()),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
