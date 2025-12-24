import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../config/theme.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

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
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final currentHabit = habitProvider.getHabit(widget.habit.id);
    
    if (currentHabit?.activeSessionStart != null) {
      _elapsedTime = DateTime.now().difference(currentHabit!.activeSessionStart!);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        final habitProvider = Provider.of<HabitProvider>(context, listen: false);
        final currentHabit = habitProvider.getHabit(widget.habit.id);
        
        if (currentHabit?.activeSessionStart != null) {
          _elapsedTime = DateTime.now().difference(currentHabit!.activeSessionStart!);
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final currentHabit = habitProvider.getHabit(widget.habit.id) ?? widget.habit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final streak = habitProvider.getCurrentStreak(currentHabit.id);
    final completionRate =
        habitProvider.getCompletionRate(currentHabit.id, days: 30);
    final hasActiveSession = currentHabit.activeSessionStart != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Symbols.arrow_back_ios_new),
                  ),
                  const Text(
                    'Detalle de Meta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Symbols.more_horiz),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    Text(
                      '${currentHabit.frequency.displayName.toUpperCase()} • SALUD',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentHabit.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentHabit.description ?? 'Sin descripción',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Timer Card
                    _buildTimerCard(context, habitProvider, currentHabit, isDark, hasActiveSession),
                    const SizedBox(height: 16),
                    
                    // Hero Card - Today's Progress
                    _buildProgressCard(context, habitProvider, currentHabit, isDark),
                    const SizedBox(height: 16),
                    
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Días Racha',
                            '$streak',
                            Symbols.local_fire_department,
                            const Color(0xFFF97316),
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Cumplimiento',
                            '${completionRate.toInt()}%',
                            Symbols.hotel_class,
                            const Color(0xFF3B82F6),
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // History Calendar
                    _buildHistorySection(context, habitProvider, currentHabit, isDark),
                    
                    const SizedBox(height: 32),
                    
                    // Delete Button
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation(context, habitProvider);
                        },
                        icon: const Icon(
                          Symbols.delete,
                          size: 18,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Eliminar Meta',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard(
    BuildContext context,
    HabitProvider habitProvider,
    Habit currentHabit,
    bool isDark,
    bool hasActiveSession,
  ) {
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
          const Icon(
            Symbols.timer,
            size: 48,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            hasActiveSession ? 'Sesión en progreso' : 'Tiempo de hábito',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveSession ? _formatDuration(_elapsedTime) : '00:00:00',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (hasActiveSession) {
                  await habitProvider.finishSession(currentHabit.id);
                  _stopTimer();
                  setState(() {
                    _elapsedTime = Duration.zero;
                  });
                  if (context.mounted) {
                    // Calcular minutos antes de que se limpie la sesión
                    final minutes = _elapsedTime.inMinutes;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sesión finalizada: $minutes minutos',
                        ),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  }
                } else {
                  await habitProvider.startSession(currentHabit.id);
                  _startTimer();
                }
              },
              icon: Icon(
                hasActiveSession ? Symbols.stop_circle : Symbols.play_circle,
                size: 20,
              ),
              label: Text(
                hasActiveSession ? 'Finalizar' : 'Iniciar',
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

  Widget _buildProgressCard(
    BuildContext context,
    HabitProvider habitProvider,
    Habit currentHabit,
    bool isDark,
  ) {
    final today = dateOnly(DateTime.now());
    final completion = habitProvider.getCompletionForDate(currentHabit.id, today);
    final isCompleted = completion?.completed ?? false;

    return Container(
      width: double.infinity,
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
          // Image Section
          Container(
            height: 192,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(int.parse(currentHabit.colorHex)).withOpacity(0.3),
                  Color(int.parse(currentHabit.colorHex)).withOpacity(0.1),
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    _getIconData(currentHabit.icon),
                    size: 80,
                    color: Color(int.parse(currentHabit.colorHex)),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.today,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Progreso de hoy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCompleted ? '¡Completado!' : 'Pendiente',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCompleted
                              ? 'Meta cumplida hoy'
                              : 'Marca como completado',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    // Circular Progress
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppTheme.primary.withOpacity(0.2)
                            : (isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[200]),
                      ),
                      child: Center(
                        child: Text(
                          isCompleted ? '100%' : '0%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? AppTheme.primary
                                : (isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: isCompleted ? 1.0 : 0.0,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await habitProvider.toggleCompletion(currentHabit.id, today);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.backgroundDark,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCompleted ? Symbols.close : Symbols.check_circle,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCompleted
                              ? 'Desmarcar'
                              : 'Marcar como completado',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
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
    );
  }

  Widget _buildHistorySection(
    BuildContext context,
    HabitProvider habitProvider,
    Habit currentHabit,
    bool isDark,
  ) {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Historial',
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
                ),
                Text(
                  DateFormat('MMMM yyyy', 'es').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Symbols.chevron_right, size: 20),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Calendar
        Container(
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
              // Weekday Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['L', 'M', 'X', 'J', 'V', 'S', 'D']
                    .map((day) => SizedBox(
                          width: 32,
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              
              // Days Grid
              _buildHistoryCalendar(context, habitProvider, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCalendar(
    BuildContext context,
    HabitProvider habitProvider,
    bool isDark,
  ) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
      ),
      itemCount: startWeekday - 1 + daysInMonth,
      itemBuilder: (context, index) {
        if (index < startWeekday - 1) {
          return const SizedBox.shrink();
        }

        final day = index - startWeekday + 2;
        final date = DateTime(now.year, now.month, day);
        final completion = habitProvider.getCompletionForDate(widget.habit.id, date);
        final isCompleted = completion?.completed ?? false;
        final isFuture = date.isAfter(now);
        final minutes = completion?.minutes ?? 0;

        return GestureDetector(
          onTap: isFuture
              ? null
              : () async {
                  await habitProvider.toggleCompletion(widget.habit.id, date);
                },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.primary
                  : (isFuture
                      ? (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[100])
                      : (isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white)),
              shape: BoxShape.circle,
              border: isCompleted
                  ? null
                  : Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey[300]!,
                    ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 10,
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted
                        ? AppTheme.backgroundDark
                        : (isFuture
                            ? (isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey[400])
                            : (isDark
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight)),
                  ),
                ),
                if (minutes > 0)
                  Text(
                    '${minutes}m',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? AppTheme.backgroundDark
                          : AppTheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, HabitProvider habitProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar meta'),
        content:
            const Text('¿Estás seguro de que quieres eliminar esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              habitProvider.deleteHabit(widget.habit.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
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
    };

    return iconMap[iconName] ?? Symbols.star;
  }
}
