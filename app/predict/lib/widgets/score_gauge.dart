import 'package:flutter/material.dart';

class ScoreGauge extends StatelessWidget {
  final double score;

  const ScoreGauge({super.key, required this.score});

  Color getScoreColor(double score) {
    if (score >= 85) return Colors.greenAccent;
    if (score >= 70) return Colors.lightGreen;
    if (score >= 55) return Colors.amber;
    if (score >= 40) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.1),
            ),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(getScoreColor(score)),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 42,
                  ),
                ),
                Text(
                  '/100',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
