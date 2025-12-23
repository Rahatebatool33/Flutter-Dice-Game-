import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class GradientContainer extends StatefulWidget {
  const GradientContainer({
    super.key,
    required this.color1,
    required this.color2,
  });

  final Color color1;
  final Color color2;

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer>
    with SingleTickerProviderStateMixin {
  int diceNumber = 1;
  int score = 0;

  late AnimationController _animationController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  // Roll dice with animation
  void rollDice() {
    int finalNumber = Random().nextInt(6) + 1;

    _animationController.forward(from: 0);

    int rolls = 8; // intermediate rolls
    Duration interval = const Duration(milliseconds: 50);

    for (int i = 0; i < rolls; i++) {
      Future.delayed(interval * i, () {
        setState(() {
          diceNumber = Random().nextInt(6) + 1;
        });
      });
    }

    Future.delayed(interval * rolls, () {
      setState(() {
        diceNumber = finalNumber;

        if (finalNumber == 1) {
          score = 0;
        } else if (finalNumber == 6) {
          score += 10;
          _confettiController.play();
        } else {
          score += finalNumber;
        }
      });
    });
  }

  // Custom messages for each dice number
  String get gameMessage {
    if (score >= 50) return '🎉 YOU WON! What a champion!';
    switch (diceNumber) {
      case 1:
        return '💥 Oops! Snake eyes! Back to zero!';
      case 2:
        return '🎯 Good start! Keep rolling!';
      case 3:
        return '🔥 Nice! Midway boost!';
      case 4:
        return '⚡ Wow! Feeling lucky?';
      case 5:
        return '✨ Excellent! Almost there!';
      case 6:
        return '🎉 JACKPOT! +10 points!';
      default:
        return 'Roll the dice!';
    }
  }

  // Reset game
  void resetGame() {
    setState(() {
      score = 0;
      diceNumber = 1;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color1,
                widget.color2,
                const Color(0xFF0EA5E9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Confetti effect
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Color(0xFF0EA5E9),
                  Color(0xFF38BDF8),
                  Color(0xFFA5F3FC),
                ],
              ),
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Text
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          '🎲 DICE CHALLENGE 🎲',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Score: $score / 50',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),

                    // Dice Image with Rotation Animation
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0EA5E9).withOpacity(0.4),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/dice-$diceNumber.png',
                          width: 170,
                        ),
                      ),
                    ),

                    // Game Message Text
                    Text(
                      gameMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFE2E8F0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Roll / Restart Button
                    ElevatedButton(
                      onPressed: score < 50 ? rollDice : resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            score < 50 ? const Color(0xFF0EA5E9) : Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 42,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 12,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      child: Text(score < 50 ? 'ROLL DICE' : 'RESTART'),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


