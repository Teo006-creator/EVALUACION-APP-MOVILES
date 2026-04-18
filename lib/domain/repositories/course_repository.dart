import '../entities/course.dart';

abstract class ICourseRepository {
  Future<List<Course>> getAllCourses();
  Future<Course?> getCourseById(String id);
  Future<List<Course>> getCoursesByCategory(String category);
  Future<List<Course>> searchCourses(String query);
}
