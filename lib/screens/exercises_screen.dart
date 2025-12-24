import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import '../config/theme.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final exercises = exerciseProvider.activeExercises;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      ),
      body: exercises.isEmpty
          ? _buildEmptyState(context, isDark)
          : Column(
              children: [
                // Botón Iniciar en la parte superior
                _buildQuickStartButton(context, exercises, exerciseProvider, isDark),
                
                // Resumen y Gráfico del Mes
                _buildMonthSummary(context, exercises, exerciseProvider, isDark),
                
                // Últimas 7 sesiones
                _buildRecentSessions(context, exercises, exerciseProvider, isDark),
                
                // Lista de Ejercicios
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _buildExerciseCard(context, exercise, exerciseProvider, isDark);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/exercise-create');
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.backgroundDark, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.fitness_center,
            size: 80,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes ejercicios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un ejercicio para comenzar',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSummary(BuildContext context, List<Exercise> exercises, ExerciseProvider provider, bool isDark) {
    // Obtener todas las sesiones del mes actual
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    int totalSessions = 0;
    int totalReps = 0;
    int totalTime = 0;
    
    for (var exercise in exercises) {
      for (var session in exercise.sessions) {
        if (session.date.isAfter(startOfMonth.subtract(const Duration(days: 1)))) {
          totalSessions++;
          totalReps += session.completedReps;
          totalTime += session.totalSeconds;
        }
      }
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Symbols.calendar_month,
                color: AppTheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM yyyy', 'es_ES').format(now),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Estadísticas del mes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Sesiones',
                totalSessions.toString(),
                Symbols.fitness_center,
                isDark,
              ),
              _buildStatItem(
                'Repeticiones',
                totalReps.toString(),
                Symbols.repeat,
                isDark,
              ),
              _buildStatItem(
                'Tiempo',
                _formatMinutes(totalTime),
                Symbols.timer,
                isDark,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Gráfico del mes
          SizedBox(
            height: 150,
            child: _buildMonthChart(exercises, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthChart(List<Exercise> exercises, bool isDark) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    // Contar sesiones por día
    final Map<int, int> sessionsPerDay = {};
    for (var exercise in exercises) {
      for (var session in exercise.sessions) {
        if (session.date.year == now.year && session.date.month == now.month) {
          final day = session.date.day;
          sessionsPerDay[day] = (sessionsPerDay[day] ?? 0) + 1;
        }
      }
    }
    
    // Crear puntos para el gráfico
    final spots = <FlSpot>[];
    for (int day = 1; day <= daysInMonth; day++) {
      final count = sessionsPerDay[day] ?? 0;
      spots.add(FlSpot(day.toDouble(), count.toDouble()));
    }
    
    if (spots.every((spot) => spot.y == 0)) {
      return Center(
        child: Text(
          'Sin sesiones este mes',
          style: TextStyle(
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
        ),
      );
    }
    
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: maxY > 3 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 5,
              getTitlesWidget: (value, meta) {
                if (value == meta.max || value == meta.min) return const SizedBox();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: daysInMonth.toDouble(),
        minY: 0,
        maxY: (maxY + 1).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: spot.y > 0 ? 3 : 0,
                  color: AppTheme.primary,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} sesiones',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _formatMinutes(int seconds) {
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }

  Widget _buildExerciseCard(
    BuildContext context,
    Exercise exercise,
    ExerciseProvider provider,
    bool isDark,
  ) {
    final todaySession = provider.getTodaySession(exercise.id);
    final isCompletedToday = todaySession != null &&
        todaySession.completedSets >= todaySession.targetSets;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/exercise-detail',
          arguments: exercise,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(int.parse(exercise.colorHex)).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(exercise.icon),
                color: Color(int.parse(exercise.colorHex)),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.defaultSets} tandas × ${exercise.defaultReps} reps',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                  if (todaySession != null) ...[
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final todaySessions = Provider.of<ExerciseProvider>(context).getTodaySessions(exercise.id);
                        final totalSessions = todaySessions.length;
                        return Text(
                          totalSessions > 1
                              ? 'Hoy: ${todaySession.completedSets}/${todaySession.targetSets} tandas ($totalSessions sesiones)'
                              : 'Hoy: ${todaySession.completedSets}/${todaySession.targetSets} tandas',
                          style: TextStyle(
                            fontSize: 12,
                            color: isCompletedToday
                                ? AppTheme.primary
                                : (isDark ? Colors.orange : Colors.orange.shade700),
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            // Start Button
            ElevatedButton(
              onPressed: () {
                if (isCompletedToday) {
                  _showRestartDialog(context, exercise, isDark);
                } else {
                  Navigator.pushNamed(
                    context,
                    '/exercise-session',
                    arguments: exercise,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompletedToday ? Colors.green : AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(
                isCompletedToday 
                    ? 'Nueva' 
                    : (todaySession == null ? 'Iniciar' : 'Continuar'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestartDialog(BuildContext context, Exercise exercise, bool isDark) async {
    final provider = Provider.of<ExerciseProvider>(context, listen: false);
    final todaySessions = provider.getTodaySessions(exercise.id);
    final todaySession = provider.getTodaySession(exercise.id);
    
    // Si hay una sesión en progreso (no completada), guardarla automáticamente
    if (todaySession != null && todaySession.completedSets < todaySession.targetSets) {
      await provider.addSession(
        exercise.id,
        todaySession,
      );
    }
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva sesión'),
        content: Text(
          todaySessions.length == 1
              ? '¿Quieres hacer otra sesión del ejercicio hoy? Tu progreso actual se guardará.'
              : '¿Quieres hacer otra sesión del ejercicio hoy? Ya tienes ${todaySessions.length} sesiones guardadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushNamed(
                context,
                '/exercise-session',
                arguments: exercise,
              );
            },
            child: const Text(
              'Iniciar Nueva',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fitness_center':
        return Symbols.fitness_center;
      case 'directions_run':
        return Symbols.directions_run;
      case 'self_improvement':
        return Symbols.self_improvement;
      case 'sports_gymnastics':
        return Symbols.sports_gymnastics;
      case 'pool':
        return Symbols.pool;
      case 'sports_martial_arts':
        return Symbols.sports_martial_arts;
      case 'accessibility':
        return Symbols.accessibility;
      default:
        return Symbols.fitness_center;
    }
  }

  Widget _buildQuickStartButton(BuildContext context, List<Exercise> exercises, ExerciseProvider provider, bool isDark) {
    if (exercises.isEmpty) return const SizedBox();
    
    // Usar el primer ejercicio activo
    final firstExercise = exercises.first;
    final todaySession = provider.getTodaySession(firstExercise.id);
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ElevatedButton.icon(
        onPressed: () async {
          // Si hay sesión activa, guardarla
          if (todaySession != null && todaySession.completedSets < todaySession.targetSets) {
            await provider.addSession(firstExercise.id, todaySession);
          }
          
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              '/exercise-session',
              arguments: firstExercise,
            );
          }
        },
        icon: const Icon(Symbols.play_circle, size: 20),
        label: Text(
          'Iniciar ${firstExercise.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSessions(BuildContext context, List<Exercise> exercises, ExerciseProvider provider, bool isDark) {
    // Recopilar todas las sesiones de todos los ejercicios
    final allSessions = <Map<String, dynamic>>[];
    
    for (var exercise in exercises) {
      for (var session in exercise.sessions) {
        allSessions.add({
          'exercise': exercise,
          'session': session,
        });
      }
    }
    
    // Ordenar por fecha descendente y tomar las últimas 7
    allSessions.sort((a, b) => b['session'].date.compareTo(a['session'].date));
    final recentSessions = allSessions.take(7).toList();
    
    if (recentSessions.isEmpty) return const SizedBox();
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            'Últimas 7 Sesiones',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...recentSessions.map((item) {
            final exercise = item['exercise'] as Exercise;
            final session = item['session'];
            final completionPercent = (session.completedSets / session.targetSets * 100).round();
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(int.parse(exercise.colorHex)).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconData(exercise.icon),
                      color: Color(int.parse(exercise.colorHex)),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${DateFormat('dd MMM', 'es_ES').format(session.date)} • ${session.completedReps} reps',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: completionPercent >= 100 
                          ? AppTheme.primary.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$completionPercent%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: completionPercent >= 100 
                            ? AppTheme.primary
                            : Colors.orange,
                      ),
                    ),
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
