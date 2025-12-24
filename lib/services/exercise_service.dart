import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';

class ExerciseService {
  static const String _exercisesKey = 'exercises';

  static List<Exercise> loadExercises(SharedPreferences prefs) {
    final jsonString = prefs.getString(_exercisesKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Exercise.fromJson(json)).toList();
  }

  static Future<void> saveExercises(
    SharedPreferences prefs,
    List<Exercise> exercises,
  ) async {
    final jsonString = json.encode(
      exercises.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_exercisesKey, jsonString);
  }

  static Future<void> addExercise(
    SharedPreferences prefs,
    Exercise exercise,
  ) async {
    final exercises = loadExercises(prefs);
    exercises.add(exercise);
    await saveExercises(prefs, exercises);
  }

  static Future<void> updateExercise(
    SharedPreferences prefs,
    Exercise updatedExercise,
  ) async {
    final exercises = loadExercises(prefs);
    final index = exercises.indexWhere((e) => e.id == updatedExercise.id);
    if (index != -1) {
      exercises[index] = updatedExercise;
      await saveExercises(prefs, exercises);
    }
  }

  static Future<void> deleteExercise(
    SharedPreferences prefs,
    String exerciseId,
  ) async {
    final exercises = loadExercises(prefs);
    exercises.removeWhere((e) => e.id == exerciseId);
    await saveExercises(prefs, exercises);
  }

  static Future<void> addSession(
    SharedPreferences prefs,
    String exerciseId,
    ExerciseSession session,
  ) async {
    final exercises = loadExercises(prefs);
    final index = exercises.indexWhere((e) => e.id == exerciseId);
    if (index != -1) {
      final exercise = exercises[index];
      final updatedSessions = List<ExerciseSession>.from(exercise.sessions);
      
      // Siempre agregar nueva sesión (permite múltiples sesiones por día)
      updatedSessions.add(session);
      
      // Ordenar por fecha y hora
      updatedSessions.sort((a, b) => a.date.compareTo(b.date));
      
      exercises[index] = exercise.copyWith(sessions: updatedSessions);
      await saveExercises(prefs, exercises);
    }
  }
}
