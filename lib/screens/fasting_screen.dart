import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../providers/fasting_provider.dart';
import '../config/theme.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkActiveSession() {
    final fastingProvider = Provider.of<FastingProvider>(context, listen: false);
    if (fastingProvider.activeSession != null) {
      _elapsedTime = DateTime.now().difference(
        fastingProvider.activeSession!.startTime,
      );
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final fastingProvider = Provider.of<FastingProvider>(context, listen: false);
        if (fastingProvider.activeSession != null) {
          _elapsedTime = DateTime.now().difference(
            fastingProvider.activeSession!.startTime,
          );
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _elapsedTime = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String _formatDetailedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _getFastingType(Duration duration) {
    final hours = duration.inHours;
    
    if (hours >= 18) {
      return '18:6';
    } else if (hours >= 16) {
      return '16:8';
    } else if (hours >= 14) {
      return '14:10';
    } else if (hours >= 12) {
      return '12:12';
    } else {
      return 'En progreso';
    }
  }

  String _getFastingTypeDescription(String type) {
    switch (type) {
      case '18:6':
        return 'Ayuno Guerrero';
      case '16:8':
        return 'Ayuno Clásico';
      case '14:10':
        return 'Ayuno Ligero';
      case '12:12':
        return 'Ayuno Básico';
      default:
        return '';
    }
  }

  Color _getFastingTypeColor(String type) {
    switch (type) {
      case '18:6':
        return Colors.purple;
      case '16:8':
        return AppTheme.primary;
      case '14:10':
        return Colors.orange;
      case '12:12':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fastingProvider = Provider.of<FastingProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasActiveSession = fastingProvider.activeSession != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuno Intermitente'),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Timer Card
            _buildTimerCard(hasActiveSession, isDark, fastingProvider),
            
            const SizedBox(height: 24),
            
            // Calendar Card
            _buildCalendarCard(fastingProvider, isDark),
            
            const SizedBox(height: 24),
            
            // Recent Sessions
            _buildRecentSessions(fastingProvider, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard(bool hasActiveSession, bool isDark, FastingProvider fastingProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Symbols.restaurant_menu,
            size: 48,
            color: hasActiveSession ? AppTheme.primary : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            hasActiveSession ? 'Ayuno en Progreso' : 'Iniciar Ayuno',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          if (hasActiveSession) ...[
            Text(
              _formatDetailedDuration(_elapsedTime),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            // Tipo de ayuno
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getFastingTypeColor(_getFastingType(_elapsedTime)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getFastingTypeColor(_getFastingType(_elapsedTime)),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getFastingType(_elapsedTime),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getFastingTypeColor(_getFastingType(_elapsedTime)),
                    ),
                  ),
                  if (_getFastingTypeDescription(_getFastingType(_elapsedTime)).isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      _getFastingTypeDescription(_getFastingType(_elapsedTime)),
                      style: TextStyle(
                        fontSize: 14,
                        color: _getFastingTypeColor(_getFastingType(_elapsedTime)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Iniciado: ${DateFormat('HH:mm').format(fastingProvider.activeSession!.startTime)}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
              ),
            ),
          ] else ...[
            const Text(
              '00:00:00',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (hasActiveSession) {
                  await fastingProvider.finishFasting();
                  _stopTimer();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ayuno completado: ${_formatDuration(_elapsedTime)}',
                        ),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  }
                } else {
                  await fastingProvider.startFasting();
                  _startTimer();
                }
              },
              icon: Icon(
                hasActiveSession ? Symbols.stop_circle : Symbols.play_circle,
                size: 20,
              ),
              label: Text(
                hasActiveSession ? 'Finalizar Ayuno' : 'Iniciar Ayuno',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasActiveSession ? Colors.red : AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(FastingProvider fastingProvider, bool isDark) {
    final daysWithFasting = fastingProvider.getDaysWithFasting();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          // Month Navigator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month - 1,
                    );
                  });
                },
                icon: const Icon(Symbols.chevron_left),
              ),
              Text(
                DateFormat('MMMM yyyy', 'es_ES').format(_selectedMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                    );
                  });
                },
                icon: const Icon(Symbols.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) {
              return SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: firstWeekday % 7 + daysInMonth,
            itemBuilder: (context, index) {
              final dayOffset = index - (firstWeekday % 7);
              if (dayOffset < 0) {
                return const SizedBox();
              }
              
              final day = dayOffset + 1;
              final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
              final hasFasting = daysWithFasting.contains(date);
              final isToday = date.year == now.year && 
                             date.month == now.month && 
                             date.day == now.day;

              return Container(
                decoration: BoxDecoration(
                  color: hasFasting
                      ? AppTheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday
                      ? Border.all(color: AppTheme.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: hasFasting
                              ? AppTheme.primary
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      if (hasFasting)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions(FastingProvider fastingProvider, bool isDark) {
    final sessions = fastingProvider.sessions.reversed.take(10).toList();
    
    if (sessions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Center(
          child: Text(
            'No hay sesiones registradas',
            style: TextStyle(
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sesiones Recientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sessions.map((session) {
            final duration = Duration(minutes: session.durationMinutes);
            final fastingType = _getFastingType(duration);
            final fastingTypeColor = _getFastingTypeColor(fastingType);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy', 'es_ES').format(session.startTime),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${DateFormat('HH:mm').format(session.startTime)} - ${session.endTime != null ? DateFormat('HH:mm').format(session.endTime!) : ""}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: fastingTypeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: fastingTypeColor,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          fastingType,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: fastingTypeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(duration),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
