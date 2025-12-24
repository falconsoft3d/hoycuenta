import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:async';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import '../config/theme.dart';

class ExerciseSessionScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseSessionScreen({super.key, required this.exercise});

  @override
  State<ExerciseSessionScreen> createState() => _ExerciseSessionScreenState();
}

class _ExerciseSessionScreenState extends State<ExerciseSessionScreen> {
  late List<SetRecord> _setRecords;
  int _currentSetIndex = 0;
  int _currentReps = 0;
  
  // Temporizadores
  Timer? _timer;
  int _totalSeconds = 0;
  int _currentSetSeconds = 0;
  int _lastRepSeconds = 0;
  DateTime? _sessionStartTime;
  DateTime? _currentSetStartTime;
  DateTime? _lastRepTime;

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _enableWakelock();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disableWakelock();
    super.dispose();
  }

  void _enableWakelock() async {
    await WakelockPlus.enable();
  }

  void _disableWakelock() async {
    await WakelockPlus.disable();
  }

  void _startTimer() {
    _sessionStartTime = DateTime.now();
    _currentSetStartTime = DateTime.now();
    _lastRepTime = DateTime.now();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalSeconds++;
        if (_currentSetStartTime != null) {
          _currentSetSeconds = DateTime.now().difference(_currentSetStartTime!).inSeconds;
        }
        if (_lastRepTime != null) {
          _lastRepSeconds = DateTime.now().difference(_lastRepTime!).inSeconds;
        }
      });
    });
  }

  void _initializeSession() {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    final todaySession = exerciseProvider.getTodaySession(widget.exercise.id);

    // Solo continuar si hay una sesión incompleta
    if (todaySession != null && todaySession.completedSets < todaySession.targetSets) {
      // Continuar sesión existente
      _setRecords = List.from(todaySession.setRecords);
      _currentSetIndex = _setRecords.indexWhere((s) => !s.isComplete);
      if (_currentSetIndex == -1) {
        _currentSetIndex = _setRecords.length - 1;
      }
      _currentReps = _setRecords[_currentSetIndex].completedReps;
      _totalSeconds = todaySession.totalSeconds;
    } else {
      // Nueva sesión (no hay sesión o ya está completada)
      _setRecords = List.generate(
        widget.exercise.defaultSets,
        (index) => SetRecord(
          setNumber: index + 1,
          completedReps: 0,
          targetReps: widget.exercise.defaultReps,
        ),
      );
      _currentSetIndex = 0;
      _currentReps = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentSet = _setRecords[_currentSetIndex];
    final isCurrentSetComplete = _currentReps >= currentSet.targetReps;
    final allComplete = _setRecords.every((s) => s.isComplete);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        actions: [
          // Botón para iniciar nueva sesión
          IconButton(
            onPressed: _startNewSession,
            icon: const Icon(Icons.refresh, size: 24),
            tooltip: 'Nueva Sesión',
            color: AppTheme.primary,
          ),
          // Botón para guardar progreso y salir
          TextButton.icon(
            onPressed: _saveAndExit,
            icon: const Icon(Icons.save, size: 20),
            label: const Text('Guardar'),
            style: TextButton.styleFrom(
              foregroundColor: Color(int.parse(widget.exercise.colorHex)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tiempo Total
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            child: Center(
              child: Text(
                'Tiempo Total: ${_formatTime(_totalSeconds)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(int.parse(widget.exercise.colorHex)),
                ),
              ),
            ),
          ),
          
          // Progress Header
          Container(
            padding: const EdgeInsets.all(24),
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      'Tanda',
                      '${_currentSetIndex + 1}/${_setRecords.length}',
                      _formatTime(_currentSetSeconds),
                      isDark,
                    ),
                    _buildStatColumn(
                      'Repeticiones',
                      '$_currentReps/${currentSet.targetReps}',
                      _formatTime(_lastRepSeconds),
                      isDark,
                    ),
                    _buildStatColumn(
                      'Total',
                      '${_getTotalCompleted()}/${_getTotalTarget()}',
                      '${_getTotalCompleted()} reps',
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _getTotalCompleted() / _getTotalTarget(),
                  minHeight: 8,
                  backgroundColor: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(int.parse(widget.exercise.colorHex)),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Current Rep Counter
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(int.parse(widget.exercise.colorHex)),
                        width: 8,
                      ),
                      color: Color(int.parse(widget.exercise.colorHex))
                          .withOpacity(0.1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_currentReps',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse(widget.exercise.colorHex)),
                            ),
                          ),
                          Text(
                            'de ${currentSet.targetReps}',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Add Rep Button
                  ElevatedButton(
                    onPressed: !isCurrentSetComplete
                        ? () {
                            setState(() {
                              if (_currentReps < currentSet.targetReps) {
                                _currentReps++;
                                
                                // Calcular tiempo por rep
                                final repTime = _lastRepTime != null 
                                    ? DateTime.now().difference(_lastRepTime!).inSeconds
                                    : 0;
                                
                                _setRecords[_currentSetIndex] = SetRecord(
                                  setNumber: currentSet.setNumber,
                                  completedReps: _currentReps,
                                  targetReps: currentSet.targetReps,
                                  secondsPerRep: repTime,
                                  totalSeconds: _currentSetSeconds,
                                );
                                
                                // Resetear tiempo de última rep
                                _lastRepTime = DateTime.now();
                                _lastRepSeconds = 0;
                              }
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse(widget.exercise.colorHex)),
                      foregroundColor: AppTheme.backgroundDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isCurrentSetComplete ? '✓ Tanda Completa' : '+1 Repetición',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Next Set / Finish Button
                  if (isCurrentSetComplete && !allComplete)
                    TextButton(
                      onPressed: _nextSet,
                      child: Text(
                        'Siguiente Tanda →',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(int.parse(widget.exercise.colorHex)),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  if (allComplete)
                    ElevatedButton(
                      onPressed: _finishSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: AppTheme.backgroundDark,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '🎉 Finalizar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Sets Grid
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tandas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _setRecords.asMap().entries.map((entry) {
                    final index = entry.key;
                    final set = entry.value;
                    final isCurrent = index == _currentSetIndex;
                    final isComplete = set.isComplete;

                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isComplete
                            ? Color(int.parse(widget.exercise.colorHex))
                            : (isCurrent
                                ? Color(int.parse(widget.exercise.colorHex))
                                    .withOpacity(0.2)
                                : (isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.grey[200])),
                        borderRadius: BorderRadius.circular(12),
                        border: isCurrent
                            ? Border.all(
                                color: Color(int.parse(widget.exercise.colorHex)),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${set.setNumber}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isComplete
                                  ? AppTheme.backgroundDark
                                  : (isCurrent
                                      ? Color(int.parse(widget.exercise.colorHex))
                                      : (isDark
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight)),
                            ),
                          ),
                          Text(
                            '${set.completedReps}/${set.targetReps}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isComplete
                                  ? AppTheme.backgroundDark
                                  : (isCurrent
                                      ? Color(int.parse(widget.exercise.colorHex))
                                      : (isDark
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String time, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 10,
            color: Color(int.parse(widget.exercise.colorHex)),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  int _getTotalCompleted() {
    return _setRecords.fold(0, (sum, set) => sum + set.completedReps);
  }

  int _getTotalTarget() {
    return _setRecords.fold(0, (sum, set) => sum + set.targetReps);
  }

  void _nextSet() {
    if (_currentSetIndex < _setRecords.length - 1) {
      setState(() {
        // Guardar tiempo de la tanda actual
        _setRecords[_currentSetIndex] = SetRecord(
          setNumber: _setRecords[_currentSetIndex].setNumber,
          completedReps: _setRecords[_currentSetIndex].completedReps,
          targetReps: _setRecords[_currentSetIndex].targetReps,
          secondsPerRep: _setRecords[_currentSetIndex].secondsPerRep,
          totalSeconds: _currentSetSeconds,
        );
        
        _currentSetIndex++;
        _currentReps = _setRecords[_currentSetIndex].completedReps;
        
        // Resetear tiempo de tanda actual
        _currentSetStartTime = DateTime.now();
        _currentSetSeconds = 0;
        _lastRepTime = DateTime.now();
        _lastRepSeconds = 0;
      });
    }
  }

  void _finishSession() async {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);

    // Guardar tiempo de la última tanda
    _setRecords[_currentSetIndex] = SetRecord(
      setNumber: _setRecords[_currentSetIndex].setNumber,
      completedReps: _setRecords[_currentSetIndex].completedReps,
      targetReps: _setRecords[_currentSetIndex].targetReps,
      secondsPerRep: _setRecords[_currentSetIndex].secondsPerRep,
      totalSeconds: _currentSetSeconds,
    );

    final session = ExerciseSession(
      date: DateTime.now(),
      completedSets: _setRecords.where((s) => s.isComplete).length,
      targetSets: _setRecords.length,
      completedReps: _getTotalCompleted(),
      targetReps: _getTotalTarget(),
      totalSeconds: _totalSeconds,
      setRecords: _setRecords,
    );

    await exerciseProvider.addSession(widget.exercise.id, session);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Sesión completada! 🎉\nTiempo total: ${_formatTime(_totalSeconds)}'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  void _saveAndExit() async {
    // Guardar tiempo de la tanda actual
    _setRecords[_currentSetIndex] = SetRecord(
      setNumber: _setRecords[_currentSetIndex].setNumber,
      completedReps: _currentReps,
      targetReps: _setRecords[_currentSetIndex].targetReps,
      secondsPerRep: _setRecords[_currentSetIndex].secondsPerRep,
      totalSeconds: _currentSetSeconds,
    );

    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    final session = ExerciseSession(
      date: DateTime.now(),
      completedSets: _setRecords.where((s) => s.isComplete).length,
      targetSets: _setRecords.length,
      completedReps: _getTotalCompleted(),
      targetReps: _getTotalTarget(),
      totalSeconds: _totalSeconds,
      setRecords: _setRecords,
    );

    await exerciseProvider.addSession(widget.exercise.id, session);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Progreso guardado ✓\n${_getTotalCompleted()}/${_getTotalTarget()} reps • ${_formatTime(_totalSeconds)}'
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _startNewSession() async {
    // Guardar sesión actual primero
    _setRecords[_currentSetIndex] = SetRecord(
      setNumber: _setRecords[_currentSetIndex].setNumber,
      completedReps: _currentReps,
      targetReps: _setRecords[_currentSetIndex].targetReps,
      secondsPerRep: _setRecords[_currentSetIndex].secondsPerRep,
      totalSeconds: _currentSetSeconds,
    );

    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    final session = ExerciseSession(
      date: DateTime.now(),
      completedSets: _setRecords.where((s) => s.isComplete).length,
      targetSets: _setRecords.length,
      completedReps: _getTotalCompleted(),
      targetReps: _getTotalTarget(),
      totalSeconds: _totalSeconds,
      setRecords: _setRecords,
    );

    await exerciseProvider.addSession(widget.exercise.id, session);

    // Reiniciar todo para nueva sesión
    setState(() {
      _setRecords = List.generate(
        widget.exercise.defaultSets,
        (index) => SetRecord(
          setNumber: index + 1,
          completedReps: 0,
          targetReps: widget.exercise.defaultReps,
        ),
      );
      _currentSetIndex = 0;
      _currentReps = 0;
      _totalSeconds = 0;
      _currentSetSeconds = 0;
      _lastRepSeconds = 0;
      _sessionStartTime = DateTime.now();
      _currentSetStartTime = DateTime.now();
      _lastRepTime = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión anterior guardada ✓ Nueva sesión iniciada'),
          backgroundColor: AppTheme.primary,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
