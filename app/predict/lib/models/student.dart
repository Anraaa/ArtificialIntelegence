// lib/models/student.dart
class Student {
  final String studentId;
  final int weeklySelfStudyHours;
  final double attendancePercentage;
  final double classParticipation;
  final double totalScore;
  final String grade;

  Student({
    required this.studentId,
    required this.weeklySelfStudyHours,
    required this.attendancePercentage,
    required this.classParticipation,
    required this.totalScore,
    required this.grade,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      weeklySelfStudyHours: json['weekly_self_study_hours'],
      attendancePercentage: (json['attendance_percentage'] as num).toDouble(),
      classParticipation: (json['class_participation'] as num).toDouble(),
      totalScore: (json['total_score'] as num).toDouble(),
      grade: json['grade'],
    );
  }
}
