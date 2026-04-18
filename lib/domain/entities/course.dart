import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String name;
  final String description;
  final String instructor;
  final int durationHours;
  final CourseStatus status;
  final String category;

  const Course({
    required this.id,
    required this.name,
    required this.description,
    required this.instructor,
    required this.durationHours,
    required this.status,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    instructor,
    durationHours,
    status,
    category,
  ];
}

enum CourseStatus { available, inProgress, completed }

extension CourseStatusExtension on CourseStatus {
  String get displayName {
    switch (this) {
      case CourseStatus.available:
        return 'Disponible';
      case CourseStatus.inProgress:
        return 'En Progreso';
      case CourseStatus.completed:
        return 'Completado';
    }
  }
}
