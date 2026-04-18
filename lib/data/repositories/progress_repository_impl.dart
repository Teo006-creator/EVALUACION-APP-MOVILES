import '../../domain/entities/student_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_database.dart';
import '../models/progress_model.dart';

class ProgressRepositoryImpl implements IProgressRepository {
  final LocalDatabase localDatabase;

  ProgressRepositoryImpl(this.localDatabase);

  @override
  Future<List<StudentProgress>> getAllProgress() async {
    return await localDatabase.getAllProgress();
  }

  @override
  Future<StudentProgress?> getProgressByCourseId(String courseId) async {
    return await localDatabase.getProgressByCourseId(courseId);
  }

  @override
  Future<StudentProgress?> getProgressByStudentId(String studentId) async {
    return null;
  }

  @override
  Future<void> updateProgress(StudentProgress progress) async {
    await localDatabase.updateProgress(ProgressModel.fromEntity(progress));
  }

  @override
  Future<void> simulateProgressUpdate(String courseId, double increment) async {
    await localDatabase.simulateProgressUpdate(courseId, increment);
  }
}
