import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../config/theme.dart';

class HabitsConfigScreen extends StatelessWidget {
  const HabitsConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final habits = habitProvider.habits;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Symbols.arrow_back_ios_new),
                  ),
                  const Expanded(
                    child: Text(
                      'Configuración de Metas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            // Title and Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mis Metas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestiona tus objetivos diarios y semanales.',
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
            const SizedBox(height: 24),
            
            // Habits List
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            'No tienes metas configuradas',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Presiona + para agregar una nueva meta',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return _buildHabitItem(
                          context,
                          habit,
                          isDark,
                          () {
                            _showEditHabitModal(context, habit);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHabitModal(context);
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.backgroundDark, size: 28),
      ),
    );
  }

  Widget _buildHabitItem(
    BuildContext context,
    Habit habit,
    bool isDark,
    VoidCallback onEdit,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          // Edit Button
          IconButton(
            onPressed: onEdit,
            icon: Icon(
              Symbols.edit,
              color: isDark ? Colors.white54 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HabitFormModal(),
    );
  }

  void _showEditHabitModal(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HabitFormModal(habit: habit),
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
      'repeat': Symbols.repeat,
      'calendar_month': Symbols.calendar_month,
    };

    return iconMap[iconName] ?? Symbols.star;
  }
}

// Modal Form para Agregar/Editar Hábito
class HabitFormModal extends StatefulWidget {
  final Habit? habit;

  const HabitFormModal({super.key, this.habit});

  @override
  State<HabitFormModal> createState() => _HabitFormModalState();
}

class _HabitFormModalState extends State<HabitFormModal> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late HabitFrequency _selectedFrequency;
  late String _selectedIcon;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.habit?.description ?? '');
    _selectedFrequency = widget.habit?.frequency ?? HabitFrequency.daily;
    _selectedIcon = widget.habit?.icon ?? HabitIcons.icons[0]['icon'];
    _selectedColor =
        widget.habit?.colorHex ?? HabitIcons.icons[0]['color'].toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF15271E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 12),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.habit == null ? 'Nueva Meta' : 'Editar Meta',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Symbols.close),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              const SizedBox(height: 24),
              
              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    Text(
                      'Nombre de la meta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Ej. Meditar 10 mins',
                        suffixIcon: const Icon(Symbols.edit_note),
                        filled: true,
                        fillColor: isDark
                            ? AppTheme.surfaceInput
                            : const Color(0xFFF8FAFB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Frequency Selector
                    Text(
                      'Frecuencia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFrequencyButton(
                            'Diaria',
                            HabitFrequency.daily,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFrequencyButton(
                            'Semanal',
                            HabitFrequency.weekly,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFrequencyButton(
                            'Mensual',
                            HabitFrequency.monthly,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Icon Selector
                    Text(
                      'Icono',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: HabitIcons.icons.map((iconData) {
                        final icon = iconData['icon'] as String;
                        final color = iconData['color'] as int;
                        final isSelected = _selectedIcon == icon &&
                            _selectedColor == color.toString();

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                              _selectedColor = color.toString();
                            });
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Color(color).withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: AppTheme.primary,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              _getIconData(icon),
                              color: Color(color),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Description Field
                    Text(
                      'Descripción (Opcional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Añade detalles para motivarte...',
                        filled: true,
                        fillColor: isDark
                            ? AppTheme.surfaceInput
                            : const Color(0xFFF8FAFB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        if (widget.habit != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _deleteHabit(context);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ),
                        if (widget.habit != null) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              _saveHabit(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Symbols.check, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.habit == null
                                      ? 'Guardar Meta'
                                      : 'Actualizar',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyButton(
    String label,
    HabitFrequency frequency,
    bool isDark,
  ) {
    final isSelected = _selectedFrequency == frequency;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : (isDark ? AppTheme.surfaceInput : const Color(0xFFF8FAFB)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.shade300),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? AppTheme.backgroundDark
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  void _saveHabit(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un nombre')),
      );
      return;
    }

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final habit = Habit(
      id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      frequency: _selectedFrequency,
      icon: _selectedIcon,
      colorHex: _selectedColor,
      createdAt: widget.habit?.createdAt ?? DateTime.now(),
    );

    if (widget.habit == null) {
      habitProvider.addHabit(habit);
    } else {
      habitProvider.updateHabit(habit);
    }

    Navigator.pop(context);
  }

  void _deleteHabit(BuildContext context) {
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
              final habitProvider =
                  Provider.of<HabitProvider>(context, listen: false);
              habitProvider.deleteHabit(widget.habit!.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close modal
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
