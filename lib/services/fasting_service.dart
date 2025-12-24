import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fasting.dart';

class FastingService {
  static const String _sessionsKey = 'fasting_sessions';
  static const String _activeSessionKey = 'active_fasting_session';

  // Obtener todas las sesiones
  static List<FastingSession> getAllSessions(SharedPreferences prefs) {
    final sessionsJson = prefs.getString(_sessionsKey);
    if (sessionsJson == null || sessionsJson.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = json.decode(sessionsJson);
    return decoded.map((item) => FastingSession.fromJson(item)).toList();
  }

  // Guardar sesiones
  static Future<void> _saveSessions(
    SharedPreferences prefs,
    List<FastingSession> sessions,
  ) async {
    final encoded = json.encode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_sessionsKey, encoded);
  }

  // Obtener sesión activa
  static FastingSession? getActiveSession(SharedPreferences prefs) {
    final sessionJson = prefs.getString(_activeSessionKey);
    if (sessionJson == null || sessionJson.isEmpty) {
      return null;
    }
    return FastingSession.fromJson(json.decode(sessionJson));
  }

  // Guardar sesión activa
  static Future<void> _saveActiveSession(
    SharedPreferences prefs,
    FastingSession? session,
  ) async {
    if (session == null) {
      await prefs.remove(_activeSessionKey);
    } else {
      await prefs.setString(_activeSessionKey, json.encode(session.toJson()));
    }
  }

  // Iniciar nuevo ayuno
  static Future<FastingSession> startFasting(SharedPreferences prefs) async {
    final session = FastingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      isActive: true,
    );

    await _saveActiveSession(prefs, session);
    return session;
  }

  // Finalizar ayuno
  static Future<void> finishFasting(SharedPreferences prefs) async {
    final activeSession = getActiveSession(prefs);
    if (activeSession == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(activeSession.startTime);

    final completedSession = FastingSession(
      id: activeSession.id,
      startTime: activeSession.startTime,
      endTime: endTime,
      durationMinutes: duration.inMinutes,
      isActive: false,
    );

    // Agregar a historial
    final sessions = getAllSessions(prefs);
    sessions.add(completedSession);
    await _saveSessions(prefs, sessions);

    // Limpiar sesión activa
    await _saveActiveSession(prefs, null);
  }

  // Obtener sesiones por fecha
  static List<FastingSession> getSessionsForDate(
    SharedPreferences prefs,
    DateTime date,
  ) {
    final sessions = getAllSessions(prefs);
    return sessions.where((s) {
      final sessionDate = s.startTime;
      return sessionDate.year == date.year &&
          sessionDate.month == date.month &&
          sessionDate.day == date.day;
    }).toList();
  }

  // Obtener días con ayuno
  static Set<DateTime> getDaysWithFasting(SharedPreferences prefs) {
    final sessions = getAllSessions(prefs);
    return sessions.map((s) {
      final date = s.startTime;
      return DateTime(date.year, date.month, date.day);
    }).toSet();
  }
}
