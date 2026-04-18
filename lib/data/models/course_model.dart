import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.instructor,
    required super.durationHours,
    required super.status,
    required super.category,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      instructor: map['instructor'] as String,
      durationHours: map['duration_hours'] as int,
      status: CourseStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => CourseStatus.available,
      ),
      category: map['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructor': instructor,
      'duration_hours': durationHours,
      'status': status.name,
      'category': category,
    };
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      name: course.name,
      description: course.description,
      instructor: course.instructor,
      durationHours: course.durationHours,
      status: course.status,
      category: course.category,
    );
  }
}
