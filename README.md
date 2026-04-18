# EduCourses - App de Gestión de Cursos

Aplicación móvil Flutter para el seguimiento de estudiantes en cursos cortos, desarrollada con **Clean Architecture** y **Riverpod**.

## Proyecto Académico

**Evaluación Práctica** - Desarrollo de Aplicaciones Móviles  
**Fecha:** 17/04/2026

---

## Características

- **Gestión de Cursos**: Listar, filtrar y buscar cursos
- **Progreso del Estudiante**: Visualización de avanço con indicadores animados
- **Navegación**: PageView con 3 secciones (Cursos / Progreso / Perfil)
- **Base de Datos**: SQLite local

### Arquitectura

El proyecto sigue **Clean Architecture** con 3 capas:

```
lib/
├── core/           # Constantes y tema
├── domain/         # Entidades, repositorios (interfaces), casos de uso
├── data/           # Modelos, implementaciones, base de datos SQLite
└── presentation/  # Providers (Riverpod), pantallas, widgets
```

---

## Cómo Ejecutar

### 1. Clonar el repositorio
```bash
git clone https://github.com/Teo006-creator/EVALUACION-APP-MOVILES.git
cd EVALUACION-APP-MOVILES
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Buildar el APK (IMPORTANTE)

**Requisitos:**
- Java 17 (no usar Java 26+)
- Flutter SDK

**Comando:**
```bash
# Linux/Mac
JAVA_HOME=/usr/lib/jvm/java-17-openjdk flutter build apk --debug

# Windows
set JAVA_HOME=C:\Program Files\Java\jdk-17
flutter build apk --debug
```

El APK se generará en:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### 4. Ejecutar en dispositivo/emulador
```bash
flutter run
```

---

## Requisitos del Sistema

- **Flutter**: 3.41+
- **Dart**: 3.11+
- **Java**: JDK 17 (no usar JDK 26+)

---

## Problemas Comunes

### Error: "databaseFactory not initialized"
Si ejecutas en desktop (Linux/Mac/Windows), el código ya incluye el fix automático con sqflite_common_ffi.

### Error de Gradle con Java 26
Usar Java 17:
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
flutter build apk --debug
```

---

## Estructura del Proyecto

| Carpeta | Descripción |
|---------|-------------|
| `domain/entities` | Entidades: Course, StudentProgress, Student |
| `domain/repositories` | Interfaces de repositorios |
| `domain/usecases` | Casos de uso (GetCourses, UpdateProgress) |
| `data/models` | Modelos con mapeo a SQLite |
| `data/repositories` | Implementaciones de repositorios |
| `data/datasources` | Base de datos local SQLite |
| `presentation/providers` | Providers Riverpod |
| `presentation/screens` | Pantallas: Courses, Progress, Profile |
| `presentation/widgets` | Widgets reutilizables |

---

## Capturas de Pantalla

La app incluye:
- Listado de cursos con Cards
- Filtro por categorías
- Búsqueda de cursos
- Indicadores de progreso (CircularProgressIndicator, LinearProgressIndicator)
- Detalle de curso con simulación de progreso

---

## Evaluación

- **Correcta implementación de Clean Architecture y Riverpod**: 40%
- **Funcionalidad de la app**: 25%
- **Uso correcto de widgets requeridos**: 20%
- **Manejo de estado con Riverpod**: 10%
- **Diseño y orden del código**: 5%