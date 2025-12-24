import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../config/theme.dart';
import '../services/habit_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isGoalsExpanded = true;

  @override
  void initState() {
    super.initState();
    _updateAppBadge();
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAppBadge();
  }

  Future<void> _updateAppBadge() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final activeHabits = habitProvider.activeHabits;
    final today = dateOnly(DateTime.now());
    
    final pendingCount = activeHabits.where((habit) {
      final completion = habitProvider.getCompletionForDate(habit.id, today);
      return !(completion?.completed ?? false);
    }).length;
    
    if (pendingCount > 0) {
      FlutterAppBadger.updateBadgeCount(pendingCount);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final summary = habitProvider.getTodaySummary();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Actualizar badge cuando cambian los datos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAppBadge();
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, habitProvider, isDark),
            
            // Contenido scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    
                    // Today's Summary Card
                    _buildSummaryCard(context, summary, isDark),
                    
                    const SizedBox(height: 24),
                    
                    // Active Goals List
                    _buildActiveGoalsList(context, habitProvider, isDark),
                    
                    const SizedBox(height: 24),
                    
                    // Heatmap Calendar
                    _buildHeatmapSection(context, habitProvider, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HabitProvider habitProvider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          // Avatar
          FutureBuilder<int>(
            future: _calculateMaxStreak(habitProvider),
            builder: (context, snapshot) {
              final maxStreak = snapshot.data ?? 0;
              
              // Determinar icono según el nivel (>30 días = Rey, ≤30 = Iniciante)
              final isRey = maxStreak > 30;
              final icon = isRey ? Icons.emoji_events : Icons.flag;
              
              return Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isRey ? const Color(0xFFFFD700) : AppTheme.primary,
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        colors: isRey
                            ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                            : [AppTheme.primary, const Color(0xFF10B981)],
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppTheme.backgroundDark
                              : AppTheme.backgroundLight,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FutureBuilder<String?>(
                  future: habitProvider.getPreferences().then(
                    (prefs) => HabitService.getUserName(prefs)
                  ),
                  builder: (context, snapshot) {
                    final name = snapshot.data ?? 'Usuario';
                    return Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Exercises Button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/exercises');
            },
            icon: Icon(
              Symbols.fitness_center,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          // Fasting Button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/fasting');
            },
            icon: Icon(
              Symbols.restaurant_menu,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          // Measurements Button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/measurements');
            },
            icon: Icon(
              Symbols.monitoring,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),          // Settings Button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: Icon(
              Symbols.settings,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getStreakTitle(int streak) {
    if (streak >= 30) return '👑 Rey';
    if (streak >= 25) return '🤴 Príncipe';
    if (streak >= 20) return '⚔️ Caballero';
    if (streak >= 15) return '🛡️ Guerrero';
    if (streak >= 10) return '⭐ Héroe';
    if (streak >= 7) return '🌟 Destacado';
    if (streak >= 5) return '💪 Fuerte';
    if (streak >= 3) return '🔥 En Racha';
    if (streak >= 1) return '🌱 Iniciando';
    return '💤 Dormido';
  }

  Widget _buildSummaryCard(
      BuildContext context, Map<String, dynamic> summary, bool isDark) {
    final percentage = summary['percentage'] as double;
    final completed = summary['completedHabits'] as int;
    final total = summary['totalHabits'] as int;
    final currentStreak = summary['currentStreak'] ?? 0;
    final streakTitle = _getStreakTitle(currentStreak as int);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de Hoy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, d MMM', 'es').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              // Streak Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Racha: $currentStreak días',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    streakTitle,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${percentage.toInt()}%',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed de $total metas completadas',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              // Mini histogram
              _buildMiniHistogram(isDark),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor:
                  isDark ? Colors.black.withOpacity(0.4) : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHistogram(bool isDark) {
    return SizedBox(
      height: 48,
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildHistogramBar(0.4, isDark),
          _buildHistogramBar(0.6, isDark),
          _buildHistogramBar(0.3, isDark),
          _buildHistogramBar(0.8, isDark),
          _buildHistogramBar(0.2, isDark),
        ],
      ),
    );
  }

  Widget _buildHistogramBar(double value, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 48 * value,
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(value),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        ),
      ),
    );
  }

  Widget _buildHeatmapSection(
      BuildContext context, HabitProvider habitProvider, bool isDark) {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tu Actividad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.chevron_left, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isDark ? AppTheme.surfaceDark : Colors.grey[200],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy', 'es').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.chevron_right, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isDark ? AppTheme.surfaceDark : Colors.grey[200],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Heatmap Calendar
        _buildHeatmapCalendar(context, habitProvider, isDark),
      ],
    );
  }

  Widget _buildHeatmapCalendar(
      BuildContext context, HabitProvider habitProvider, bool isDark) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;

    return Container(
      padding: const EdgeInsets.all(16),
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
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                .map((day) => SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          // Calendar Grid
          GridView.builder(
            key: ValueKey('heatmap_${habitProvider.habits.length}_${DateTime.now().millisecondsSinceEpoch}'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: startWeekday - 1 + daysInMonth,
            itemBuilder: (context, index) {
              // Empty cells before first day
              if (index < startWeekday - 1) {
                return const SizedBox.shrink();
              }

              final day = index - startWeekday + 2;
              final date = DateTime(now.year, now.month, day);
              final isToday = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;
              final isFuture = date.isAfter(now);

              // Calculate completion for this day
              double completionRate = _getCompletionRateForDate(
                habitProvider,
                date,
              );

              return _buildDayCell(
                day,
                completionRate,
                isToday,
                isFuture,
                isDark,
              );
            },
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Menos',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 8),
              _buildLegendBox(0, isDark),
              _buildLegendBox(0.3, isDark),
              _buildLegendBox(0.6, isDark),
              _buildLegendBox(1.0, isDark),
              const SizedBox(width: 8),
              Text(
                'Más',
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
  }

  double _getCompletionRateForDate(HabitProvider habitProvider, DateTime date) {
    final activeHabits = habitProvider.activeHabits;
    if (activeHabits.isEmpty) return 0;

    int completedCount = 0;
    for (var habit in activeHabits) {
      final completion = habitProvider.getCompletionForDate(habit.id, date);
      if (completion != null && completion.completed) {
        completedCount++;
      }
    }

    return completedCount / activeHabits.length;
  }

  Widget _buildDayCell(
    int day,
    double completionRate,
    bool isToday,
    bool isFuture,
    bool isDark,
  ) {
    Color backgroundColor;
    Color textColor;
    
    if (isFuture) {
      backgroundColor = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.grey.withOpacity(0.1);
      textColor = isDark
          ? Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.4);
    } else if (completionRate == 0) {
      backgroundColor = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.grey.withOpacity(0.1);
      textColor = isDark
          ? AppTheme.textSecondaryDark
          : AppTheme.textSecondaryLight;
    } else {
      backgroundColor = AppTheme.primary.withOpacity(completionRate);
      textColor = completionRate > 0.5
          ? AppTheme.backgroundDark
          : (isDark ? Colors.white70 : Colors.black87);
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppTheme.primary, width: 2)
            : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? AppTheme.backgroundDark : textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendBox(double opacity, bool isDark) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: opacity == 0
            ? (isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.1))
            : AppTheme.primary.withOpacity(opacity),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildActiveGoalsList(
      BuildContext context, HabitProvider habitProvider, bool isDark) {
    final activeHabits = habitProvider.activeHabits;
    final today = dateOnly(DateTime.now());
    
    // Contar tareas pendientes de hoy
    final pendingCount = activeHabits.where((habit) {
      final completion = habitProvider.getCompletionForDate(habit.id, today);
      return !(completion?.completed ?? false);
    }).length;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isGoalsExpanded = !_isGoalsExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Metas Activas',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (pendingCount > 0 && !_isGoalsExpanded) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '$pendingCount',
                          style: const TextStyle(
                            color: AppTheme.backgroundDark,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    if (_isGoalsExpanded)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/habits-config');
                        },
                        child: const Text(
                          'Ver todo',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Icon(
                      _isGoalsExpanded
                          ? Symbols.expand_less
                          : Symbols.expand_more,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isGoalsExpanded) ...[
          const SizedBox(height: 12),
          if (activeHabits.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Symbols.add_circle_outline,
                      size: 64,
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes hábitos activos',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...activeHabits.take(3).map((habit) {
              final completion =
                  habitProvider.getCompletionForDate(habit.id, today);
              final isCompleted = completion?.completed ?? false;

              return _buildGoalItem(
                context,
                habit,
                isCompleted,
                isDark,
                () async {
                  await habitProvider.toggleCompletion(habit.id, today);
                  _updateAppBadge();
                },
                () {
                  Navigator.pushNamed(
                    context,
                    '/habit-detail',
                    arguments: habit,
                  );
                },
              );
            }),
        ],
      ],
    );
  }

  Widget _buildGoalItem(
    BuildContext context,
    Habit habit,
    bool isCompleted,
    bool isDark,
    VoidCallback onToggle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(int.parse(habit.colorHex)).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(habit.icon),
                color: Color(int.parse(habit.colorHex)),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getIconData(habit.frequency.iconName),
                        size: 12,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        habit.frequency.displayName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? AppTheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.primary
                        : (isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 20,
                        color: AppTheme.backgroundDark,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Mapeo de nombres de iconos a IconData
    final iconMap = {
      'local_drink': Symbols.local_drink,
      'menu_book': Symbols.menu_book,
      'directions_run': Symbols.directions_run,
      'self_improvement': Symbols.self_improvement,
      'restaurant': Symbols.restaurant,
      'bedtime': Symbols.bedtime,
      'music_note': Symbols.music_note,
      'brush': Symbols.brush,
      'code': Symbols.code,
      'fitness_center': Symbols.fitness_center,
      'spa': Symbols.spa,
      'school': Symbols.school,
      'repeat': Symbols.repeat,
      'calendar_month': Symbols.calendar_month,
    };

    return iconMap[iconName] ?? Symbols.star;
  }

  Future<int> _calculateMaxStreak(HabitProvider habitProvider) async {
    final prefs = await habitProvider.getPreferences();
    final habitService = HabitService(prefs);
    final habits = habitProvider.habits;
    
    int maxStreak = 0;
    for (var habit in habits) {
      final streak = habitService.getCurrentStreak(habit.id);
      if (streak > maxStreak) {
        maxStreak = streak;
      }
    }
    
    return maxStreak;
  }
}
