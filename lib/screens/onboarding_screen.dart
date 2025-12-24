import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../config/theme.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../services/habit_service.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final TextEditingController _nameController = TextEditingController();
  final List<Habit> _selectedHabits = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            if (_currentPage > 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / 3,
                  backgroundColor: isDark
                      ? Colors.white.withAlpha(26)
                      : Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(isDark),
                  _buildNamePage(isDark),
                  _buildHabitsPage(isDark),
                ],
              ),
            ),
            
            // Navigation Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == 2 ? 'Comenzar' : 'Siguiente',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.emoji_events,
              size: 64,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '¡Bienvenido a HoyCuenta!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Construye hábitos positivos y alcanza tus metas día a día',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildFeatureItem(
            Symbols.calendar_month,
            'Visualiza tu progreso',
            'Calendario tipo GitHub para ver tu consistencia',
            isDark,
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            Symbols.local_fire_department,
            'Mantén tu racha',
            'Motívate con tus días consecutivos de éxito',
            isDark,
          ),
          const SizedBox(height: 24),
          _buildFeatureItem(
            Symbols.insights,
            'Analiza tus estadísticas',
            'Descubre patrones y mejora continuamente',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNamePage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Symbols.person,
            size: 80,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 32),
          const Text(
            '¿Cómo te llamas?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Personaliza tu experiencia con tu nombre',
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Escribe tu nombre',
              prefixIcon: Icon(Symbols.edit),
            ),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            autofocus: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsPage(bool isDark) {
    final suggestedHabits = [
      {'icon': 'local_drink', 'color': 0xFF3B82F6, 'name': 'Beber 2L de agua'},
      {'icon': 'menu_book', 'color': 0xFF8B5CF6, 'name': 'Leer 30 mins'},
      {'icon': 'directions_run', 'color': 0xFFF97316, 'name': 'Hacer ejercicio'},
      {'icon': 'self_improvement', 'color': 0xFF10B981, 'name': 'Meditar'},
      {'icon': 'restaurant', 'color': 0xFFEF4444, 'name': 'Comer saludable'},
      {'icon': 'bedtime', 'color': 0xFF6366F1, 'name': 'Dormir 8 horas'},
      {'icon': 'code', 'color': 0xFF06B6D4, 'name': 'Programar'},
      {'icon': 'fitness_center', 'color': 0xFFDC2626, 'name': 'Ir al gimnasio'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Symbols.flag,
            size: 80,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 32),
          const Text(
            '¿Qué hábitos quieres construir?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Selecciona uno o más hábitos para comenzar (puedes agregar más después)',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: suggestedHabits.length,
              itemBuilder: (context, index) {
                final habit = suggestedHabits[index];
                final isSelected = _selectedHabits.any(
                  (h) => h.name == habit['name'],
                );

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedHabits.removeWhere(
                          (h) => h.name == habit['name'],
                        );
                      } else {
                        _selectedHabits.add(
                          Habit(
                            id: DateTime.now().millisecondsSinceEpoch.toString() +
                                index.toString(),
                            name: habit['name'] as String,
                            frequency: HabitFrequency.daily,
                            icon: habit['icon'] as String,
                            colorHex: (habit['color'] as int).toString(),
                            createdAt: DateTime.now(),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withAlpha(51)
                          : (isDark ? AppTheme.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : (isDark
                                ? Colors.white.withAlpha(13)
                                : Colors.black.withAlpha(13)),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconData(habit['icon'] as String),
                          size: 40,
                          color: Color(habit['color'] as int),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          habit['name'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onNextPressed() async {
    if (_currentPage < 2) {
      if (_currentPage == 1 && _nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingresa tu nombre')),
        );
        return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_selectedHabits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor selecciona al menos un hábito')),
        );
        return;
      }

      // Guardar nombre y hábitos
      final habitProvider =
          Provider.of<HabitProvider>(context, listen: false);
      
      // Obtener preferences una sola vez
      final prefs = await habitProvider.getPreferences();
      
      // Guardar nombre
      await HabitService.saveUserName(prefs, _nameController.text.trim());

      // Guardar hábitos
      for (var habit in _selectedHabits) {
        await habitProvider.addHabit(habit);
      }

      // Marcar onboarding como completado
      await HabitService.setOnboardingCompleted(prefs);

      // Navegar al dashboard
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'local_drink': Symbols.local_drink,
      'menu_book': Symbols.menu_book,
      'directions_run': Symbols.directions_run,
      'self_improvement': Symbols.self_improvement,
      'restaurant': Symbols.restaurant,
      'bedtime': Symbols.bedtime,
      'code': Symbols.code,
      'fitness_center': Symbols.fitness_center,
    };
    return iconMap[iconName] ?? Symbols.star;
  }
}
