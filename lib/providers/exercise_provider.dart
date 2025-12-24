import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../services/exercise_service.dart';

class ExerciseProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  List<Exercise> _exercises = [];

  ExerciseProvider(this.prefs) {
    _loadData();
  }

  List<Exercise> get exercises => _exercises;
  
  List<Exercise> get activeExercises =>
      _exercises.where((e) => e.isActive).toList();

  void _loadData() {
    _exercises = ExerciseService.loadExercises(prefs);
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    await ExerciseService.addExercise(prefs, exercise);
    _loadData();
  }

  Future<void> updateExercise(Exercise exercise) async {
    await ExerciseService.updateExercise(prefs, exercise);
    _loadData();
  }

  Future<void> deleteExercise(String exerciseId) async {
    await ExerciseService.deleteExercise(prefs, exerciseId);
    _loadData();
  }

  Future<void> addSession(String exerciseId, ExerciseSession session) async {
    await ExerciseService.addSession(prefs, exerciseId, session);
    _loadData();
  }

  Exercise? getExerciseById(String id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  ExerciseSession? getTodaySession(String exerciseId) {
    final exercise = getExerciseById(exerciseId);
    if (exercise == null) return null;

    final today = DateTime.now();
    final todaySessions = exercise.sessions.where(
      (s) => s.date.year == today.year &&
             s.date.month == today.month &&
             s.date.day == today.day,
    ).toList();
    
    // Devolver la última sesión del día si existe
    return todaySessions.isEmpty ? null : todaySessions.last;
  }

  List<ExerciseSession> getTodaySessions(String exerciseId) {
    final exercise = getExerciseById(exerciseId);
    if (exercise == null) return [];

    final today = DateTime.now();
    return exercise.sessions.where(
      (s) => s.date.year == today.year &&
             s.date.month == today.month &&
             s.date.day == today.day,
    ).toList();
  }
}
