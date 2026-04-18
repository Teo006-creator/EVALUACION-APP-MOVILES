import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/course.dart';
import '../providers/app_providers.dart';
import '../widgets/progress_widgets.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final progressAsync = ref.watch(courseProgressProvider(courseId));
    final progressNotifier = ref.read(progressNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Curso')),
      body: courseAsync.when(
        data: (course) {
          if (course == null) {
            return const Center(child: Text('Curso no encontrado'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  course.status,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getStatusIcon(course.status),
                                    size: 16,
                                    color: _getStatusColor(course.status),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    course.status.displayName,
                                    style: TextStyle(
                                      color: _getStatusColor(course.status),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                course.category,
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              course.instructor,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${course.durationHours} horas',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progreso del Estudiante',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        progressAsync.when(
                          data: (progress) {
                            if (progress == null) {
                              return const Text(
                                'Sin progreso registrado',
                                style: TextStyle(color: AppTheme.textSecondary),
                              );
                            }
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ProgressWidget(
                                      percentage: progress.progressPercentage,
                                      size: 100,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildInfoItem(
                                      Icons.book,
                                      'Lecciones',
                                      '${progress.lessonsCompleted}/${progress.totalLessons}',
                                    ),
                                    _buildInfoItem(
                                      Icons.check_circle,
                                      'Estado',
                                      progress.isCompleted
                                          ? 'Completado'
                                          : 'En Progreso',
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) =>
                              const Text('Error al cargar progreso'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await progressNotifier.simulateProgress(courseId, 10);
                      ref.invalidate(courseProgressProvider(courseId));
                      ref.invalidate(progressListProvider);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Simular Avance (+10%)'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.available:
        return AppTheme.secondaryColor;
      case CourseStatus.inProgress:
        return AppTheme.accentColor;
      case CourseStatus.completed:
        return AppTheme.primaryColor;
    }
  }

  IconData _getStatusIcon(CourseStatus status) {
    switch (status) {
      case CourseStatus.available:
        return Icons.play_circle_outline;
      case CourseStatus.inProgress:
        return Icons.refresh;
      case CourseStatus.completed:
        return Icons.check_circle;
    }
  }
}
