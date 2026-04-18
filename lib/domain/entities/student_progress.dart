import 'package:equatable/equatable.dart';

class StudentProgress extends Equatable {
  final String id;
  final String courseId;
  final String studentId;
  final double progressPercentage;
  final int lessonsCompleted;
  final int totalLessons;
  final DateTime lastUpdated;
  final bool isCompleted;

  const StudentProgress({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.progressPercentage,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.lastUpdated,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
    id,
    courseId,
    studentId,
    progressPercentage,
    lessonsCompleted,
    totalLessons,
    lastUpdated,
    isCompleted,
  ];
}
