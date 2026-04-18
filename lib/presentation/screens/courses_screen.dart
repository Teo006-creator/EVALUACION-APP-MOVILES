import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/course.dart';
import '../providers/app_providers.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_widgets.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(filteredCoursesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Column(
      children: [
        CourseSearchBar(
          controller: _searchController,
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          onClear: () {
            ref.read(searchQueryProvider.notifier).state = '';
          },
        ),
        categoriesAsync.when(
          data: (categories) => FilterChips(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
          ),
          loading: () => const SizedBox(height: 50),
          error: (_, __) => const SizedBox(height: 50),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: coursesAsync.when(
            data: (courses) => _buildCoursesList(courses),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildCoursesList(List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppTheme.textSecondary),
            SizedBox(height: 16),
            Text(
              'No se encontraron cursos',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(coursesProvider);
        ref.invalidate(filteredCoursesProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return FutureBuilder(
            future: ref.read(courseProgressProvider(course.id).future),
            builder: (context, snapshot) {
              double? progress;
              if (snapshot.hasData && snapshot.data != null) {
                progress = snapshot.data!.progressPercentage;
              }
              return CourseCard(
                course: course,
                progress: progress,
                onTap: () => _navigateToDetail(course),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetail(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(courseId: course.id),
      ),
    );
  }
}
