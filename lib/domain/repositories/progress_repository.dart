import '../entities/student_progress.dart';

abstract class IProgressRepository {
  Future<List<StudentProgress>> getAllProgress();
  Future<StudentProgress?> getProgressByCourseId(String courseId);
  Future<StudentProgress?> getProgressByStudentId(String studentId);
  Future<void> updateProgress(StudentProgress progress);
  Future<void> simulateProgressUpdate(String courseId, double increment);
}
