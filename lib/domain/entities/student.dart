import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime enrolledDate;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.enrolledDate,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, enrolledDate];
}
