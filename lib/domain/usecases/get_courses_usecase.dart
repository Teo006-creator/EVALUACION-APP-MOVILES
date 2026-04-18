import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCoursesUseCase {
  final ICourseRepository repository;

  GetCoursesUseCase(this.repository);

  Future<List<Course>> call() async {
    return await repository.getAllCourses();
  }
}

class GetCourseDetailUseCase {
  final ICourseRepository repository;

  GetCourseDetailUseCase(this.repository);

  Future<Course?> call(String courseId) async {
    return await repository.getCourseById(courseId);
  }
}

class SearchCoursesUseCase {
  final ICourseRepository repository;

  SearchCoursesUseCase(this.repository);

  Future<List<Course>> call(String query) async {
    return await repository.searchCourses(query);
  }
}

class GetCoursesByCategoryUseCase {
  final ICourseRepository repository;

  GetCoursesByCategoryUseCase(this.repository);

  Future<List<Course>> call(String category) async {
    return await repository.getCoursesByCategory(category);
  }
}
