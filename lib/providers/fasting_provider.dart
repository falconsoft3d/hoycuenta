import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fasting.dart';
import '../services/fasting_service.dart';

class FastingProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  FastingSession? _activeSession;
  List<FastingSession> _sessions = [];

  FastingProvider(this.prefs) {
    _loadData();
  }

  FastingSession? get activeSession => _activeSession;
  List<FastingSession> get sessions => _sessions;

  void _loadData() {
    _activeSession = FastingService.getActiveSession(prefs);
    _sessions = FastingService.getAllSessions(prefs);
    notifyListeners();
  }

  Future<void> startFasting() async {
    _activeSession = await FastingService.startFasting(prefs);
    notifyListeners();
  }

  Future<void> finishFasting() async {
    await FastingService.finishFasting(prefs);
    _activeSession = null;
    _loadData();
  }

  List<FastingSession> getSessionsForDate(DateTime date) {
    return FastingService.getSessionsForDate(prefs, date);
  }

  Set<DateTime> getDaysWithFasting() {
    return FastingService.getDaysWithFasting(prefs);
  }
}
