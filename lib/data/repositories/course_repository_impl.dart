import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/local_database.dart';

class CourseRepositoryImpl implements ICourseRepository {
  final LocalDatabase localDatabase;

  CourseRepositoryImpl(this.localDatabase);

  @override
  Future<List<Course>> getAllCourses() async {
    return await localDatabase.getAllCourses();
  }

  @override
  Future<Course?> getCourseById(String id) async {
    return await localDatabase.getCourseById(id);
  }

  @override
  Future<List<Course>> getCoursesByCategory(String category) async {
    return await localDatabase.getCoursesByCategory(category);
  }

  @override
  Future<List<Course>> searchCourses(String query) async {
    return await localDatabase.searchCourses(query);
  }
}
