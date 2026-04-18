import '../entities/student_progress.dart';
import '../repositories/progress_repository.dart';

class GetStudentProgressUseCase {
  final IProgressRepository repository;

  GetStudentProgressUseCase(this.repository);

  Future<List<StudentProgress>> call() async {
    return await repository.getAllProgress();
  }
}

class GetCourseProgressUseCase {
  final IProgressRepository repository;

  GetCourseProgressUseCase(this.repository);

  Future<StudentProgress?> call(String courseId) async {
    return await repository.getProgressByCourseId(courseId);
  }
}

class UpdateProgressUseCase {
  final IProgressRepository repository;

  UpdateProgressUseCase(this.repository);

  Future<void> call(StudentProgress progress) async {
    return await repository.updateProgress(progress);
  }
}

class SimulateProgressUseCase {
  final IProgressRepository repository;

  SimulateProgressUseCase(this.repository);

  Future<void> call(String courseId, double increment) async {
    return await repository.simulateProgressUpdate(courseId, increment);
  }
}
