import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import '../config/theme.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final ex = exerciseProvider.getExerciseById(exercise.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (ex == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ejercicio')),
        body: const Center(child: Text('Ejercicio no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(ex.name),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        actions: [
          IconButton(
            icon: const Icon(Symbols.delete),
            onPressed: () => _showDeleteDialog(context, ex),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Chart
          if (ex.sessions.isNotEmpty) ...[
            _buildChartCard(context, ex, isDark),
            const SizedBox(height: 16),
          ],

          // Statistics
          if (ex.sessions.isNotEmpty) ...[
            _buildStatisticsCard(context, ex, isDark),
            const SizedBox(height: 16),
          ],

          // History
          _buildHistoryCard(context, ex, isDark),
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, Exercise exercise, bool isDark) {
    final sessions = exercise.sessions;
    if (sessions.isEmpty) return const SizedBox.shrink();

    // Agrupar sesiones por día y calcular promedio de cumplimiento
    final Map<String, List<ExerciseSession>> sessionsByDay = {};
    for (var session in sessions) {
      final dateKey = '${session.date.year}-${session.date.month}-${session.date.day}';
      sessionsByDay.putIfAbsent(dateKey, () => []).add(session);
    }

    // Crear lista de días con promedio de cumplimiento
    final dayAverages = sessionsByDay.entries.map((entry) {
      final daySessions = entry.value;
      final avgCompletion = daySessions.fold<double>(
        0, 
        (sum, s) => sum + s.completionPercentage
      ) / daySessions.length;
      return MapEntry(daySessions.first.date, avgCompletion);
    }).toList();

    // Ordenar por fecha y tomar últimos 30 días
    dayAverages.sort((a, b) => a.key.compareTo(b.key));
    final displayData = dayAverages.length > 30
        ? dayAverages.sublist(dayAverages.length - 30)
        : dayAverages;

    final spots = displayData
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.value,
            ))
        .toList();

    return Container(
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
          Text(
            'Promedio Diario de Cumplimiento (30 días)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (displayData.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < displayData.length) {
                          final date = displayData[value.toInt()].key;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('d/M').format(date),
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Color(int.parse(exercise.colorHex)),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(int.parse(exercise.colorHex)),
                          strokeWidth: 2,
                          strokeColor: isDark ? AppTheme.surfaceDark : Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(int.parse(exercise.colorHex)).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, Exercise exercise, bool isDark) {
    final sessions = exercise.sessions;
    if (sessions.isEmpty) return const SizedBox.shrink();

    final totalSessions = sessions.length;
    final completedSessions = sessions.where((s) => s.completionPercentage >= 100).length;
    final avgCompletion = sessions.fold(0.0, (sum, s) => sum + s.completionPercentage) / totalSessions;
    final totalReps = sessions.fold(0, (sum, s) => sum + s.completedReps);

    return Container(
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
          Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Sesiones', totalSessions.toString(), '', isDark),
              ),
              Expanded(
                child: _buildStatItem('Completadas', completedSessions.toString(), '', isDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Promedio', avgCompletion.toStringAsFixed(1), '%', isDark),
              ),
              Expanded(
                child: _buildStatItem('Total Reps', totalReps.toString(), '', isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (unit.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, Exercise exercise, bool isDark) {
    // Agrupar sesiones por día
    final Map<String, List<ExerciseSession>> sessionsByDay = {};
    for (var session in exercise.sessions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(session.date);
      sessionsByDay.putIfAbsent(dateKey, () => []).add(session);
    }

    // Convertir a lista y ordenar por fecha descendente
    final dayEntries = sessionsByDay.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Container(
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
          Text(
            'Historial (últimos 10 días)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (dayEntries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No hay sesiones aún',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ),
            )
          else
            ...dayEntries.take(10).map((dayEntry) {
              final daySessions = dayEntry.value;
              final firstSession = daySessions.first;
              final totalSessions = daySessions.length;
              
              // Calcular promedios del día
              final avgCompletion = daySessions.fold<double>(
                0, 
                (sum, s) => sum + s.completionPercentage
              ) / totalSessions;
              
              final totalTime = daySessions.fold<int>(
                0, 
                (sum, s) => sum + s.totalSeconds
              );
              
              final totalReps = daySessions.fold<int>(
                0, 
                (sum, s) => sum + s.completedReps
              );

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMM yyyy', 'es').format(firstSession.date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            totalSessions > 1 
                                ? '$totalSessions sesiones • $totalReps reps totales'
                                : '${firstSession.completedSets}/${firstSession.targetSets} tandas • $totalReps reps',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                          if (totalTime > 0)
                            Text(
                              '⏱️ ${_formatTime(totalTime)}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(int.parse(exercise.colorHex)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${avgCompletion.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(exercise.colorHex)),
                          ),
                        ),
                        if (totalSessions > 1)
                          Text(
                            'promedio',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar ejercicio'),
        content: Text('¿Estás seguro de eliminar "${exercise.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final exerciseProvider = Provider.of<ExerciseProvider>(
                context,
                listen: false,
              );
              await exerciseProvider.deleteExercise(exercise.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to list
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs == 0) {
      return '${minutes}m';
    }
    return '${minutes}m ${secs}s';
  }
}
