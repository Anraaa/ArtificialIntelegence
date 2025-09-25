// lib/providers/student_provider.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';

class StudentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Student> students = [];
  bool isLoading = false;
  bool hasMore = true;
  int _offset = 0;

  Future<void> loadMoreStudents() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final newStudents = await _apiService.fetchStudents(offset: _offset);
      if (newStudents.isEmpty) {
        hasMore = false;
      } else {
        students.addAll(newStudents);
        _offset += newStudents.length;
      }
    } catch (e) {
      // Handle error jika perlu
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    students.clear();
    _offset = 0;
    hasMore = true;
    await loadMoreStudents();
  }
}
