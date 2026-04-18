import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_database.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/student_progress.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/repositories/progress_repository.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase.instance;
});

final courseRepositoryProvider = Provider<ICourseRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);
  return CourseRepositoryImpl(localDatabase);
});

final progressRepositoryProvider = Provider<IProgressRepository>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);
  return ProgressRepositoryImpl(localDatabase);
});

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final repository = ref.watch(courseRepositoryProvider);
  return await repository.getAllCourses();
});

final progressListProvider = FutureProvider<List<StudentProgress>>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  return await repository.getAllProgress();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'Todas');

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final allCourses = await ref.watch(coursesProvider.future);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  var courses = allCourses;

  if (selectedCategory != 'Todas') {
    courses = courses.where((c) => c.category == selectedCategory).toList();
  }

  if (searchQuery.isNotEmpty) {
    courses = courses
        .where(
          (c) =>
              c.name.toLowerCase().contains(searchQuery) ||
              c.description.toLowerCase().contains(searchQuery),
        )
        .toList();
  }

  return courses;
});

final courseDetailProvider = FutureProvider.family<Course?, String>((
  ref,
  courseId,
) async {
  final repository = ref.watch(courseRepositoryProvider);
  return await repository.getCourseById(courseId);
});

final courseProgressProvider = FutureProvider.family<StudentProgress?, String>((
  ref,
  courseId,
) async {
  final repository = ref.watch(progressRepositoryProvider);
  return await repository.getProgressByCourseId(courseId);
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final courses = await ref.watch(coursesProvider.future);
  final categories = courses.map((c) => c.category).toSet().toList();
  return ['Todas', ...categories];
});

class ProgressNotifier
    extends StateNotifier<AsyncValue<List<StudentProgress>>> {
  final IProgressRepository _repository;

  ProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    state = const AsyncValue.loading();
    try {
      final progress = await _repository.getAllProgress();
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> simulateProgress(String courseId, double increment) async {
    try {
      await _repository.simulateProgressUpdate(courseId, increment);
      await loadProgress();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final progressNotifierProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<List<StudentProgress>>>((
      ref,
    ) {
      final repository = ref.watch(progressRepositoryProvider);
      return ProgressNotifier(repository);
    });

final pageIndexProvider = StateProvider<int>((ref) => 0);
