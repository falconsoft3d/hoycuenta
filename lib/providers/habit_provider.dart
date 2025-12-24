import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class HabitProvider extends ChangeNotifier {
  final HabitService _habitService;
  final SharedPreferences _prefs;
  
  List<Habit> _habits = [];
  List<HabitCompletion> _completions = [];
  
  HabitProvider(this._habitService, this._prefs) {
    _loadData();
  }
  
  Future<SharedPreferences> getPreferences() async {
    return _prefs;
  }
  
  List<Habit> get habits => _habits;
  List<Habit> get activeHabits => _habits.where((h) => h.isActive).toList();
  List<HabitCompletion> get completions => _completions;
  
  void _loadData() {
    _habits = _habitService.getAllHabits();
    _completions = _habitService.getAllCompletions();
    notifyListeners();
  }
  
  Future<void> addHabit(Habit habit) async {
    await _habitService.saveHabit(habit);
    _loadData();
  }
  
  Future<void> updateHabit(Habit habit) async {
    await _habitService.saveHabit(habit);
    _loadData();
  }
  
  Future<void> deleteHabit(String habitId) async {
    await _habitService.deleteHabit(habitId);
    _loadData();
  }
  
  Future<void> toggleCompletion(String habitId, DateTime date) async {
    await _habitService.toggleCompletion(habitId, date);
    _loadData();
  }
  
  Future<void> updateProgress(String habitId, DateTime date, int progress, int target) async {
    await _habitService.updateProgress(habitId, date, progress, target);
    _loadData();
  }
  
  HabitCompletion? getCompletionForDate(String habitId, DateTime date) {
    return _habitService.getCompletionForDate(habitId, date);
  }
  
  int getCurrentStreak(String habitId) {
    return _habitService.getCurrentStreak(habitId);
  }
  
  double getCompletionRate(String habitId, {int days = 30}) {
    return _habitService.getCompletionRate(habitId, days: days);
  }
  
  Map<String, dynamic> getTodaySummary() {
    return _habitService.getTodaySummary();
  }
  
  List<HabitCompletion> getCompletionsForHabit(String habitId) {
    return _habitService.getCompletionsForHabit(habitId);
  }

  // Métodos para sesiones de tiempo
  Future<void> startSession(String habitId) async {
    await _habitService.startSession(habitId);
    _loadData();
  }

  Future<void> finishSession(String habitId) async {
    await _habitService.finishSession(habitId);
    _loadData();
  }

  Habit? getHabit(String habitId) {
    return _habitService.getHabit(habitId);
  }
}
