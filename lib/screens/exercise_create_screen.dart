import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import '../config/theme.dart';

class ExerciseCreateScreen extends StatefulWidget {
  const ExerciseCreateScreen({super.key});

  @override
  State<ExerciseCreateScreen> createState() => _ExerciseCreateScreenState();
}

class _ExerciseCreateScreenState extends State<ExerciseCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '5');
  final _repsController = TextEditingController(text: '8');
  
  String _selectedIcon = 'fitness_center';
  String _selectedColor = '0xFF2BEE79';

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'fitness_center', 'label': 'Pesas', 'icon': Symbols.fitness_center},
    {'name': 'directions_run', 'label': 'Correr', 'icon': Symbols.directions_run},
    {'name': 'self_improvement', 'label': 'Yoga', 'icon': Symbols.self_improvement},
    {'name': 'sports_gymnastics', 'label': 'Gimnasia', 'icon': Symbols.sports_gymnastics},
    {'name': 'pool', 'label': 'Nadar', 'icon': Symbols.pool},
    {'name': 'sports_martial_arts', 'label': 'Artes M.', 'icon': Symbols.sports_martial_arts},
    {'name': 'accessibility', 'label': 'Flexión', 'icon': Symbols.accessibility},
  ];

  final List<Map<String, dynamic>> _availableColors = [
    {'hex': '0xFF2BEE79', 'name': 'Verde'},
    {'hex': '0xFF3B82F6', 'name': 'Azul'},
    {'hex': '0xFFEF4444', 'name': 'Rojo'},
    {'hex': '0xFFF59E0B', 'name': 'Naranja'},
    {'hex': '0xFF8B5CF6', 'name': 'Morado'},
    {'hex': '0xFFEC4899', 'name': 'Rosa'},
    {'hex': '0xFF14B8A6', 'name': 'Turquesa'},
    {'hex': '0xFFF97316', 'name': 'Coral'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Ejercicio'),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del ejercicio',
                hintText: 'Ej: Flexiones, Sentadillas',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Sets and Reps
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tandas',
                      hintText: '5',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 1) {
                        return 'Mínimo 1';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Repeticiones',
                      hintText: '8',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 1) {
                        return 'Mínimo 1';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Icon Selection
            Text(
              'Ícono',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableIcons.map((iconData) {
                final isSelected = _selectedIcon == iconData['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconData['name'] as String;
                    });
                  },
                  child: Container(
                    width: 72,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withOpacity(0.2)
                          : (isDark ? AppTheme.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : (isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1)),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          iconData['icon'] as IconData,
                          color: isSelected
                              ? AppTheme.primary
                              : (isDark ? Colors.white70 : Colors.black54),
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          iconData['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppTheme.primary
                                : (isDark
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Color Selection
            Text(
              'Color',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _availableColors.map((colorData) {
                final isSelected = _selectedColor == colorData['hex'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorData['hex'] as String;
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorData['hex'] as String)),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(int.parse(colorData['hex'] as String))
                                    .withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            
            // Save Button
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Crear Ejercicio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      final exerciseProvider = Provider.of<ExerciseProvider>(
        context,
        listen: false,
      );

      final exercise = Exercise(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        defaultSets: int.parse(_setsController.text),
        defaultReps: int.parse(_repsController.text),
        icon: _selectedIcon,
        colorHex: _selectedColor,
      );

      await exerciseProvider.addExercise(exercise);
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
