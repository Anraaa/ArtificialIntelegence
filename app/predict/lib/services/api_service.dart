import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_response.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000';
  static const Duration _timeoutDuration = Duration(seconds: 30);

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<double> predictScore({
    required int studyHours,
    required double attendance,
    required double participation,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$_baseUrl/predict'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'weekly_self_study_hours': studyHours,
              'attendance_percentage': attendance,
              'class_participation': participation,
            }),
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return PredictionResponse.fromJson(jsonResponse).predictedScore;
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint tidak ditemukan. Periksa URL API.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Silakan coba lagi nanti.');
      } else {
        throw Exception(
          'Gagal mendapatkan prediksi. Status: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Koneksi gagal: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Format response tidak valid: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
