import 'package:flutter/material.dart';
import 'score_gauge.dart';

class ResultCard extends StatelessWidget {
  final double score;
  const ResultCard({super.key, required this.score});

  String getFeedback(double score) {
    if (score >= 85) return "Luar Biasa! Performa optimal";
    if (score >= 70) return "Sangat Baik! Pertahankan";
    if (score >= 55) return "Cukup Baik, masih bisa ditingkatkan";
    if (score >= 40) return "Perlu Peningkatan";
    return "Butuh Perhatian Khusus";
  }

  String getDescription(double score) {
    if (score >= 85) return "Konsistensi Anda membuahkan hasil yang excellent";
    if (score >= 70) return "Anda berada di jalur yang tepat, teruskan!";
    if (score >= 55) return "Ada ruang untuk improvement, semangat!";
    if (score >= 40) return "Perlu evaluasi strategi belajar";
    return "Mari evaluasi bersama untuk peningkatan";
  }

  Color getScoreColor(double score) {
    if (score >= 85) return Colors.greenAccent;
    if (score >= 70) return Colors.lightGreen;
    if (score >= 55) return Colors.amber;
    if (score >= 40) return Colors.orange;
    return Colors.redAccent;
  }

  IconData getScoreIcon(double score) {
    if (score >= 85) return Icons.emoji_events;
    if (score >= 70) return Icons.thumb_up;
    if (score >= 55) return Icons.trending_up;
    if (score >= 40) return Icons.info;
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: getScoreColor(score).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, color: Colors.white70, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Hasil Prediksi',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ScoreGauge(score: score),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getScoreColor(score).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    getScoreIcon(score),
                    color: getScoreColor(score),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getFeedback(score),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getScoreColor(score),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getDescription(score),
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tips: Tingkatkan partisipasi dan konsistensi belajar untuk hasil yang lebih baik',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
