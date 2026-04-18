import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/student_progress.dart';
import '../providers/app_providers.dart';
import '../widgets/progress_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressNotifierProvider);
    final coursesAsync = ref.watch(coursesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estudiante',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'estudiante@educacion.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: AppTheme.secondaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Estudiante Activo',
                          style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          progressAsync.when(
            data: (progressList) {
              final totalProgress = _calculateTotalProgress(progressList);
              final completedCourses = progressList
                  .where((p) => p.isCompleted)
                  .length;
              final totalLessons = progressList.fold<int>(
                0,
                (sum, p) => sum + p.lessonsCompleted,
              );
              final totalHours = coursesAsync.when(
                data: (courses) {
                  var hours = 0;
                  for (final p in progressList) {
                    final course = courses.where((c) => c.id == p.courseId);
                    if (course.isNotEmpty) {
                      final completedPercent = p.progressPercentage / 100;
                      hours += (course.first.durationHours * completedPercent)
                          .round();
                    }
                  }
                  return hours;
                },
                loading: () => 0,
                error: (_, __) => 0,
              );

              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: AppTheme.primaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Estadísticas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProgressWidget(
                                percentage: totalProgress,
                                size: 100,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatCard(
                                Icons.school,
                                'Cursos',
                                '${progressList.length}',
                                AppTheme.primaryColor,
                              ),
                              _buildStatCard(
                                Icons.check_circle,
                                'Completados',
                                '$completedCourses',
                                AppTheme.secondaryColor,
                              ),
                              _buildStatCard(
                                Icons.access_time,
                                'Horas',
                                '$totalHours',
                                AppTheme.accentColor,
                              ),
                              _buildStatCard(
                                Icons.book,
                                'Lecciones',
                                '$totalLessons',
                                Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (_, __) => const Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Error al cargar estadísticas'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Información',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.cake,
                    'Fecha de inscripción',
                    'Enero 2026',
                  ),
                  const Divider(),
                  _buildInfoRow(Icons.language, 'Idioma', 'Español'),
                  const Divider(),
                  _buildInfoRow(
                    Icons.phone_android,
                    'Dispositivo',
                    'Android/iOS',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalProgress(List<StudentProgress> progressList) {
    if (progressList.isEmpty) return 0;
    final total = progressList.fold<double>(
      0,
      (sum, p) => sum + p.progressPercentage,
    );
    return total / progressList.length;
  }
}
