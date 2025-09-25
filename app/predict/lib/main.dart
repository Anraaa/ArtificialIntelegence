// lib/main.dart
import 'package:flutter/material.dart';
import 'services/api_service.dart';

// Hapus import yang tidak terpakai
// import 'package:provider/provider.dart';
// import 'models/student.dart';
// import 'providers/student_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Karena hanya ada satu halaman, ChangeNotifierProvider tidak diperlukan lagi.
    return MaterialApp(
      title: 'Student Performance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // SOLUSI: Langsung tampilkan PredictionScreen sebagai halaman utama
      home: const PredictionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Widget HomeScreen dan StudentListScreen dihapus karena tidak digunakan lagi.

// Layar Prediksi
class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  double _studyHours = 8.0, _attendance = 90.0, _participation = 80.0;
  double? _predictedScore;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _getPrediction() async {
    setState(() => _isLoading = true);
    try {
      final score = await _apiService.predictScore(
        studyHours: _studyHours.round(),
        attendance: _attendance,
        participation: _participation,
      );
      setState(() => _predictedScore = score);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediksi Skor Siswa')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputSlider(
            label: 'Jam Belajar/Minggu',
            value: _studyHours,
            min: 0,
            max: 20,
            divisions: 20,
            onChanged: (val) => setState(() => _studyHours = val),
          ),
          InputSlider(
            label: 'Persentase Kehadiran (%)',
            value: _attendance,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (val) => setState(() => _attendance = val),
          ),
          InputSlider(
            label: 'Partisipasi Kelas (%)',
            value: _participation,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (val) => setState(() => _participation = val),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _getPrediction,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Dapatkan Prediksi'),
          ),
          if (_predictedScore != null)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: ResultCard(score: _predictedScore!),
            ),
        ],
      ),
    );
  }
}

// Widget InputSlider
class InputSlider extends StatelessWidget {
  final String label;
  final double value, min, max;
  final int divisions;
  final Function(double) onChanged;

  const InputSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ${value.round()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget ResultCard
class ResultCard extends StatelessWidget {
  final double score;
  const ResultCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Prediksi Skor Akhir:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              score.toStringAsFixed(2),
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
