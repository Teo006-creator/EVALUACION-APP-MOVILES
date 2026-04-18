import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/student_progress.dart';
import '../models/course_model.dart';
import '../models/progress_model.dart';

void _initFfi() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

class LocalDatabase {
  static bool _initialized = false;

  static void ensureInitialized() {
    if (!_initialized) {
      _initFfi();
      _initialized = true;
    }
  }

  static Database? _database;
  static final LocalDatabase instance = LocalDatabase._internal();

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'edu_courses.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE courses (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        instructor TEXT NOT NULL,
        duration_hours INTEGER NOT NULL,
        status TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE student_progress (
        id TEXT PRIMARY KEY,
        course_id TEXT NOT NULL,
        student_id TEXT NOT NULL,
        progress_percentage REAL NOT NULL,
        lessons_completed INTEGER NOT NULL,
        total_lessons INTEGER NOT NULL,
        last_updated TEXT NOT NULL,
        is_completed INTEGER NOT NULL
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final courses = [
      {
        'id': 'course_1',
        'name': 'Flutter Fundamentals',
        'description':
            'Aprende los conceptos básicos de Flutter y Dart para desarrollar aplicaciones móviles.',
        'instructor': 'Ing. Juan Pérez',
        'duration_hours': 20,
        'status': 'completed',
        'category': 'Desarrollo Móvil',
      },
      {
        'id': 'course_2',
        'name': 'Advanced Flutter',
        'description':
            'Domina técnicas avanzadas de Flutter: animaciones, rendimiento y Clean Architecture.',
        'instructor': 'Dra. María García',
        'duration_hours': 30,
        'status': 'inProgress',
        'category': 'Desarrollo Móvil',
      },
      {
        'id': 'course_3',
        'name': 'Firebase para Apps',
        'description':
            'Implementa autenticación, base de datos en tiempo real y notificaciones push.',
        'instructor': 'Ing. Carlos López',
        'duration_hours': 15,
        'status': 'available',
        'category': 'Backend',
      },
      {
        'id': 'course_4',
        'name': 'UI/UX Design',
        'description':
            'Crea interfaces de usuario atractivas y funcionales para aplicaciones móviles.',
        'instructor': 'Lic. Ana Rodríguez',
        'duration_hours': 12,
        'status': 'inProgress',
        'category': 'Diseño',
      },
      {
        'id': 'course_5',
        'name': ' Dart Avanzado',
        'description':
            'Programa orientado a objetos, patrones de diseño y técnicas de optimización.',
        'instructor': 'Ing. Roberto Mendoza',
        'duration_hours': 18,
        'status': 'available',
        'category': 'Programación',
      },
      {
        'id': 'course_6',
        'name': 'Testing en Flutter',
        'description':
            'Aprende a escribir pruebas unitarias, de widgets y de integración.',
        'instructor': 'Dra. Laura Fernández',
        'duration_hours': 10,
        'status': 'available',
        'category': 'Calidad',
      },
    ];

    final progressData = [
      {
        'id': 'progress_1',
        'course_id': 'course_1',
        'student_id': 'student_1',
        'progress_percentage': 100.0,
        'lessons_completed': 10,
        'total_lessons': 10,
        'last_updated': '2026-04-10T14:30:00Z',
        'is_completed': 1,
      },
      {
        'id': 'progress_2',
        'course_id': 'course_2',
        'student_id': 'student_1',
        'progress_percentage': 60.0,
        'lessons_completed': 9,
        'total_lessons': 15,
        'last_updated': '2026-04-15T10:00:00Z',
        'is_completed': 0,
      },
      {
        'id': 'progress_3',
        'course_id': 'course_4',
        'student_id': 'student_1',
        'progress_percentage': 25.0,
        'lessons_completed': 3,
        'total_lessons': 12,
        'last_updated': '2026-04-14T16:45:00Z',
        'is_completed': 0,
      },
    ];

    for (final course in courses) {
      await db.insert('courses', course);
    }

    for (final progress in progressData) {
      await db.insert('student_progress', progress);
    }
  }

  Future<List<CourseModel>> getAllCourses() async {
    final db = await database;
    final maps = await db.query('courses');
    return maps.map((map) => CourseModel.fromMap(map)).toList();
  }

  Future<CourseModel?> getCourseById(String id) async {
    final db = await database;
    final maps = await db.query('courses', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return CourseModel.fromMap(maps.first);
  }

  Future<List<CourseModel>> getCoursesByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((map) => CourseModel.fromMap(map)).toList();
  }

  Future<List<CourseModel>> searchCourses(String query) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((map) => CourseModel.fromMap(map)).toList();
  }

  Future<List<ProgressModel>> getAllProgress() async {
    final db = await database;
    final maps = await db.query('student_progress');
    return maps.map((map) => ProgressModel.fromMap(map)).toList();
  }

  Future<ProgressModel?> getProgressByCourseId(String courseId) async {
    final db = await database;
    final maps = await db.query(
      'student_progress',
      where: 'course_id = ?',
      whereArgs: [courseId],
    );
    if (maps.isEmpty) return null;
    return ProgressModel.fromMap(maps.first);
  }

  Future<void> updateProgress(ProgressModel progress) async {
    final db = await database;
    await db.update(
      'student_progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  Future<void> simulateProgressUpdate(String courseId, double increment) async {
    final db = await database;
    final existing = await getProgressByCourseId(courseId);

    if (existing != null) {
      double newPercentage = (existing.progressPercentage + increment).clamp(
        0.0,
        100.0,
      );
      int newLessons = ((newPercentage / 100) * existing.totalLessons).round();
      bool isCompleted = newPercentage >= 100.0;

      await db.update(
        'student_progress',
        {
          'progress_percentage': newPercentage,
          'lessons_completed': newLessons,
          'last_updated': DateTime.now().toIso8601String(),
          'is_completed': isCompleted ? 1 : 0,
        },
        where: 'course_id = ?',
        whereArgs: [courseId],
      );
    }
  }
}
