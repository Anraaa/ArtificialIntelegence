// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  // GANTI IP INI!
  // Emulator Android: '10.0.2.2'
  // Perangkat Fisik: Gunakan IP lokal komputer Anda (cek dengan 'ipconfig' atau 'ifconfig')
  static const String _baseUrl = 'http://10.0.2.2:5000';

  Future<List<Student>> fetchStudents({int offset = 0, int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/students?offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data siswa');
    }
  }

  Future<double> predictScore({
    required int studyHours,
    required double attendance,
    required double participation,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'weekly_self_study_hours': studyHours,
        'attendance_percentage': attendance,
        'class_participation': participation,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['predicted_score'];
    } else {
      throw Exception('Gagal mendapatkan prediksi');
    }
  }
}
