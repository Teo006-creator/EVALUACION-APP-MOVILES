import '../../domain/entities/student_progress.dart';

class ProgressModel extends StudentProgress {
  const ProgressModel({
    required super.id,
    required super.courseId,
    required super.studentId,
    required super.progressPercentage,
    required super.lessonsCompleted,
    required super.totalLessons,
    required super.lastUpdated,
    required super.isCompleted,
  });

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      studentId: map['student_id'] as String,
      progressPercentage: (map['progress_percentage'] as num).toDouble(),
      lessonsCompleted: map['lessons_completed'] as int,
      totalLessons: map['total_lessons'] as int,
      lastUpdated: DateTime.parse(map['last_updated'] as String),
      isCompleted: map['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'student_id': studentId,
      'progress_percentage': progressPercentage,
      'lessons_completed': lessonsCompleted,
      'total_lessons': totalLessons,
      'last_updated': lastUpdated.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory ProgressModel.fromEntity(StudentProgress progress) {
    return ProgressModel(
      id: progress.id,
      courseId: progress.courseId,
      studentId: progress.studentId,
      progressPercentage: progress.progressPercentage,
      lessonsCompleted: progress.lessonsCompleted,
      totalLessons: progress.totalLessons,
      lastUpdated: progress.lastUpdated,
      isCompleted: progress.isCompleted,
    );
  }
}
