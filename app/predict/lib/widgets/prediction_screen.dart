import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'input_slider.dart';
import 'result_card.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  double _studyHours = 8.0, _attendance = 90.0, _participation = 8.0;
  double? _predictedScore;
  bool _isLoading = false;
  late ApiService _apiService;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _apiService.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getPrediction() async {
    setState(() {
      _isLoading = true;
      _predictedScore = null;
    });

    try {
      final score = await _apiService.predictScore(
        studyHours: _studyHours.round(),
        attendance: _attendance,
        participation: _participation,
      );

      setState(() => _predictedScore = score);
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _studyHours = 8.0;
      _attendance = 90.0;
      _participation = 8.0;
      _predictedScore = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade700,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 32),
                _buildInputSection(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 32),
                _buildResultSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.school_outlined, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Prediktor Kinerja Siswa',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Optimalkan performa akademik dengan prediksi AI',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        InputSlider(
          label: 'Jam Belajar / Minggu',
          icon: Icons.book_outlined,
          value: _studyHours,
          min: 0,
          max: 20,
          divisions: 20,
          unit: 'jam',
          onChanged: (val) => setState(() => _studyHours = val),
        ),
        const SizedBox(height: 20),
        InputSlider(
          label: 'Persentase Kehadiran',
          icon: Icons.event_available_outlined,
          value: _attendance,
          min: 0,
          max: 100,
          divisions: 100,
          unit: '%',
          onChanged: (val) => setState(() => _attendance = val),
        ),
        const SizedBox(height: 20),
        InputSlider(
          label: 'Partisipasi Kelas',
          icon: Icons.people_outline,
          value: _participation,
          min: 0,
          max: 10,
          divisions: 10,
          unit: '/10',
          onChanged: (val) => setState(() => _participation = val),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _getPrediction,
            icon: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Icon(Icons.auto_awesome, size: 24),
            label: Text(_isLoading ? 'Memproses...' : 'Dapatkan Prediksi'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              shadowColor: Colors.amber.shade300,
            ),
          ),
        ),
        if (_predictedScore != null) ...[
          const SizedBox(width: 12),
          IconButton(
            onPressed: _resetForm,
            icon: Icon(Icons.refresh),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: EdgeInsets.all(16),
            ),
            iconSize: 24,
            color: Colors.white,
          ),
        ],
      ],
    );
  }

  Widget _buildResultSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _isLoading
          ? _buildLoadingIndicator()
          : _predictedScore != null
          ? ScaleTransition(
              scale: _scaleAnimation,
              child: ResultCard(score: _predictedScore!),
            )
          : _buildPlaceholderCard(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade700),
            strokeWidth: 6,
          ),
          const SizedBox(height: 16),
          Text(
            'Menganalisis data...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, size: 60, color: Colors.white30),
          const SizedBox(height: 16),
          Text(
            'Hasil prediksi akan muncul di sini',
            style: TextStyle(color: Colors.white54, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
