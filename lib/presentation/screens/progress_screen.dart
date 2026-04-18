import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/student_progress.dart';
import '../providers/app_providers.dart';
import '../widgets/progress_widgets.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressNotifierProvider);
    final coursesAsync = ref.watch(coursesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(progressNotifierProvider.notifier).loadProgress();
      },
      child: progressAsync.when(
        data: (progressList) {
          if (progressList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sin progreso registrado',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final totalProgress = _calculateTotalProgress(progressList);
          final completedCourses = progressList
              .where((p) => p.isCompleted)
              .length;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Progreso Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ProgressWidget(percentage: totalProgress, size: 120),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                Icons.check_circle,
                                'Completados',
                                '$completedCourses',
                                AppTheme.primaryColor,
                              ),
                              _buildStatItem(
                                Icons.pending,
                                'En Progreso',
                                '${progressList.length - completedCourses}',
                                AppTheme.accentColor,
                              ),
                              _buildStatItem(
                                Icons.book,
                                'Total',
                                '${progressList.length}',
                                AppTheme.secondaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Progreso por Curso',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final progress = progressList[index];
                  return coursesAsync.when(
                    data: (courses) {
                      final course =
                          courses
                              .where((c) => c.id == progress.courseId)
                              .firstOrNull ??
                          courses.first;
                      return _buildProgressItem(
                        context,
                        ref,
                        progress,
                        course.name,
                      );
                    },
                    loading: () => const ListTile(title: Text('Cargando...')),
                    error: (_, __) => const ListTile(title: Text('Error')),
                  );
                }, childCount: progressList.length),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProgressItem(
    BuildContext context,
    WidgetRef ref,
    StudentProgress progress,
    String courseName,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                ProgressWidget(
                  percentage: progress.progressPercentage,
                  size: 50,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AnimatedProgressBar(
                    percentage: progress.progressPercentage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${progress.lessonsCompleted}/${progress.totalLessons} lecciones',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      progress.isCompleted
                          ? Icons.check_circle
                          : Icons.access_time,
                      size: 16,
                      color: progress.isCompleted
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      progress.isCompleted ? 'Completado' : 'En Progreso',
                      style: TextStyle(
                        fontSize: 12,
                        color: progress.isCompleted
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(progressNotifierProvider.notifier)
                      .simulateProgress(progress.courseId, 10);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Simular Avance (+10%)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
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
