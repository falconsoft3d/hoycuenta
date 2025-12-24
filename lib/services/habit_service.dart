import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitService {
  static const String _habitsKey = 'habits';
  static const String _completionsKey = 'completions';
  static const String _userNameKey = 'userName';
  static const String _onboardingCompletedKey = 'onboardingCompleted';
  static const String _pinKey = 'pin';
  static const String _pinEnabledKey = 'pinEnabled';
  static const String _profilePhotoKey = 'profilePhoto';

  final SharedPreferences _prefs;

  HabitService(this._prefs);

  // === HABITS ===

  // Obtener todos los hábitos
  List<Habit> getAllHabits() {
    final String? habitsJson = _prefs.getString(_habitsKey);
    if (habitsJson == null) return [];

    final List<dynamic> habitsList = jsonDecode(habitsJson);
    return habitsList.map((json) => Habit.fromJson(json)).toList();
  }

  // Obtener hábitos activos
  List<Habit> getActiveHabits() {
    return getAllHabits().where((habit) => habit.isActive).toList();
  }

  // Guardar un hábito
  Future<void> saveHabit(Habit habit) async {
    final habits = getAllHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);

    if (index != -1) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }

    await _saveHabits(habits);
  }

  // Eliminar un hábito
  Future<void> deleteHabit(String habitId) async {
    final habits = getAllHabits();
    habits.removeWhere((h) => h.id == habitId);
    await _saveHabits(habits);

    // También eliminar todos los completions del hábito
    final completions = getAllCompletions();
    completions.removeWhere((c) => c.habitId == habitId);
    await _saveCompletions(completions);
  }

  Future<void> _saveHabits(List<Habit> habits) async {
    final String habitsJson = jsonEncode(
      habits.map((h) => h.toJson()).toList(),
    );
    await _prefs.setString(_habitsKey, habitsJson);
  }

  // === COMPLETIONS ===

  // Obtener todos los completions
  List<HabitCompletion> getAllCompletions() {
    final String? completionsJson = _prefs.getString(_completionsKey);
    if (completionsJson == null) return [];

    final List<dynamic> completionsList = jsonDecode(completionsJson);
    return completionsList
        .map((json) => HabitCompletion.fromJson(json))
        .toList();
  }

  // Obtener completions de un hábito específico
  List<HabitCompletion> getCompletionsForHabit(String habitId) {
    return getAllCompletions()
        .where((c) => c.habitId == habitId)
        .toList();
  }

  // Obtener completion para un hábito en una fecha específica
  HabitCompletion? getCompletionForDate(String habitId, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return getAllCompletions().firstWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == dateOnly.year &&
          c.date.month == dateOnly.month &&
          c.date.day == dateOnly.day,
      orElse: () => HabitCompletion(
        habitId: habitId,
        date: dateOnly,
        completed: false,
      ),
    );
  }

  // Marcar/desmarcar un hábito como completado
  Future<void> toggleCompletion(String habitId, DateTime date,
      {int? progress, int? target}) async {
    final completions = getAllCompletions();
    final dateOnly = DateTime(date.year, date.month, date.day);

    final existingIndex = completions.indexWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == dateOnly.year &&
          c.date.month == dateOnly.month &&
          c.date.day == dateOnly.day,
    );

    if (existingIndex != -1) {
      // Toggle existing completion
      completions[existingIndex] = completions[existingIndex].copyWith(
        completed: !completions[existingIndex].completed,
        progress: progress,
        target: target,
      );
    } else {
      // Create new completion
      completions.add(HabitCompletion(
        habitId: habitId,
        date: dateOnly,
        completed: true,
        progress: progress,
        target: target,
      ));
    }

    await _saveCompletions(completions);
  }

  // Guardar progreso parcial sin completar
  Future<void> updateProgress(
    String habitId,
    DateTime date,
    int progress,
    int target,
  ) async {
    final completions = getAllCompletions();
    final dateOnly = DateTime(date.year, date.month, date.day);

    final existingIndex = completions.indexWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == dateOnly.year &&
          c.date.month == dateOnly.month &&
          c.date.day == dateOnly.day,
    );

    final completed = progress >= target;

    if (existingIndex != -1) {
      completions[existingIndex] = completions[existingIndex].copyWith(
        progress: progress,
        target: target,
        completed: completed,
      );
    } else {
      completions.add(HabitCompletion(
        habitId: habitId,
        date: dateOnly,
        completed: completed,
        progress: progress,
        target: target,
      ));
    }

    await _saveCompletions(completions);
  }

  Future<void> _saveCompletions(List<HabitCompletion> completions) async {
    final String completionsJson = jsonEncode(
      completions.map((c) => c.toJson()).toList(),
    );
    await _prefs.setString(_completionsKey, completionsJson);
  }

  // === SESIONES DE TIEMPO ===

  // Iniciar sesión de tiempo para un hábito
  Future<void> startSession(String habitId) async {
    final habits = getAllHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    
    if (habitIndex != -1) {
      habits[habitIndex] = habits[habitIndex].copyWith(
        activeSessionStart: DateTime.now(),
      );
      await _saveHabits(habits);
    }
  }

  // Finalizar sesión de tiempo y guardar los minutos
  Future<void> finishSession(String habitId) async {
    final habits = getAllHabits();
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    
    if (habitIndex != -1) {
      final habit = habits[habitIndex];
      if (habit.activeSessionStart != null) {
        // Calcular minutos transcurridos
        final duration = DateTime.now().difference(habit.activeSessionStart!);
        final minutes = duration.inMinutes;
        
        // Guardar o actualizar el completion con los minutos
        await _addMinutesToCompletion(habitId, DateTime.now(), minutes);
        
        // Limpiar la sesión activa creando un nuevo hábito sin activeSessionStart
        habits[habitIndex] = Habit(
          id: habit.id,
          name: habit.name,
          description: habit.description,
          frequency: habit.frequency,
          icon: habit.icon,
          colorHex: habit.colorHex,
          createdAt: habit.createdAt,
          isActive: habit.isActive,
          activeSessionStart: null, // Explícitamente null
        );
        await _saveHabits(habits);
      }
    }
  }

  // Agregar minutos a un completion existente o crear uno nuevo
  Future<void> _addMinutesToCompletion(
    String habitId,
    DateTime date,
    int minutes,
  ) async {
    final completions = getAllCompletions();
    final dateOnly = DateTime(date.year, date.month, date.day);

    final existingIndex = completions.indexWhere(
      (c) =>
          c.habitId == habitId &&
          c.date.year == dateOnly.year &&
          c.date.month == dateOnly.month &&
          c.date.day == dateOnly.day,
    );

    if (existingIndex != -1) {
      // Sumar minutos al completion existente
      final currentMinutes = completions[existingIndex].minutes ?? 0;
      completions[existingIndex] = completions[existingIndex].copyWith(
        minutes: currentMinutes + minutes,
        completed: true, // Marcar como completado si hay tiempo registrado
      );
    } else {
      // Crear nuevo completion con minutos
      completions.add(HabitCompletion(
        habitId: habitId,
        date: dateOnly,
        completed: true,
        minutes: minutes,
      ));
    }

    await _saveCompletions(completions);
  }

  // Obtener el hábito con su sesión activa
  Habit? getHabit(String habitId) {
    final habits = getAllHabits();
    try {
      return habits.firstWhere((h) => h.id == habitId);
    } catch (e) {
      return null;
    }
  }

  // === ESTADÍSTICAS ===

  // Obtener racha actual (días consecutivos completados)
  int getCurrentStreak(String habitId) {
    final completions = getCompletionsForHabit(habitId)
      ..sort((a, b) => b.date.compareTo(a.date));

    if (completions.isEmpty) return 0;

    int streak = 0;
    final today = dateOnly(DateTime.now());
    DateTime currentDate = today;

    for (var completion in completions) {
      if (dateOnly(completion.date).isAtSameMomentAs(currentDate) &&
          completion.completed) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (dateOnly(completion.date).isBefore(currentDate)) {
        break;
      }
    }

    return streak;
  }

  // === USER DATA ===

  // Guardar nombre de usuario
  static Future<void> saveUserName(SharedPreferences prefs, String name) async {
    await prefs.setString(_userNameKey, name);
  }

  // Obtener nombre de usuario
  static String? getUserName(SharedPreferences prefs) {
    return prefs.getString(_userNameKey);
  }

  // Marcar onboarding como completado
  static Future<void> setOnboardingCompleted(SharedPreferences prefs) async {
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  // Verificar si onboarding está completado
  static bool isOnboardingCompleted(SharedPreferences prefs) {
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // Calcular porcentaje de cumplimiento
  double getCompletionRate(String habitId, {int days = 30}) {
    final completions = getCompletionsForHabit(habitId);
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    int completedDays = 0;
    int totalDays = 0;

    for (int i = 0; i < days; i++) {
      final date = dateOnly(startDate.add(Duration(days: i)));
      if (date.isAfter(dateOnly(now))) break;

      totalDays++;
      final completion = completions.firstWhere(
        (c) => dateOnly(c.date).isAtSameMomentAs(date),
        orElse: () => HabitCompletion(
          habitId: habitId,
          date: date,
          completed: false,
        ),
      );

      if (completion.completed) completedDays++;
    }

    return totalDays > 0 ? (completedDays / totalDays) * 100 : 0;
  }

  // Obtener resumen del día actual para todos los hábitos activos
  Map<String, dynamic> getTodaySummary() {
    final activeHabits = getActiveHabits();
    final today = dateOnly(DateTime.now());

    int totalHabits = activeHabits.length;
    int completedHabits = 0;

    for (var habit in activeHabits) {
      final completion = getCompletionForDate(habit.id, today);
      if (completion != null && completion.completed) {
        completedHabits++;
      }
    }

    double percentage =
        totalHabits > 0 ? (completedHabits / totalHabits) * 100 : 0;

    return {
      'totalHabits': totalHabits,
      'completedHabits': completedHabits,
      'percentage': percentage,
      'currentStreak': getCurrentOverallStreak(),
    };
  }

  // Calcular la racha general (días consecutivos con al menos un hábito completado)
  int getCurrentOverallStreak() {
    final activeHabits = getActiveHabits();
    if (activeHabits.isEmpty) return 0;

    int streak = 0;
    final today = dateOnly(DateTime.now());

    // Verificar hacia atrás desde hoy
    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      bool hasAnyCompletion = false;

      // Verificar si al menos un hábito fue completado ese día
      for (var habit in activeHabits) {
        final completion = getCompletionForDate(habit.id, checkDate);
        if (completion != null && completion.completed) {
          hasAnyCompletion = true;
          break;
        }
      }

      if (hasAnyCompletion) {
        streak++;
      } else {
        // Si es hoy y no hay completados, la racha es 0
        // Si es un día pasado y no hay completados, termina la racha
        break;
      }
    }

    return streak;
  }

  // === PIN ===

  // Guardar PIN
  static Future<void> savePin(SharedPreferences prefs, String pin) async {
    await prefs.setString(_pinKey, pin);
    await prefs.setBool(_pinEnabledKey, true);
  }

  // Obtener PIN
  static String? getPin(SharedPreferences prefs) {
    return prefs.getString(_pinKey);
  }

  // Verificar si el PIN está habilitado
  static bool isPinEnabled(SharedPreferences prefs) {
    return prefs.getBool(_pinEnabledKey) ?? false;
  }

  // Deshabilitar PIN
  static Future<void> disablePin(SharedPreferences prefs) async {
    await prefs.remove(_pinKey);
    await prefs.setBool(_pinEnabledKey, false);
  }

  // === FOTO DE PERFIL ===

  // Guardar ruta de foto de perfil
  static Future<void> saveProfilePhoto(SharedPreferences prefs, String path) async {
    await prefs.setString(_profilePhotoKey, path);
  }

  // Obtener ruta de foto de perfil
  static String? getProfilePhoto(SharedPreferences prefs) {
    return prefs.getString(_profilePhotoKey);
  }

  // Eliminar foto de perfil
  static Future<void> removeProfilePhoto(SharedPreferences prefs) async {
    await prefs.remove(_profilePhotoKey);
  }}