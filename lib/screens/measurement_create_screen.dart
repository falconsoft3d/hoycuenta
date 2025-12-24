import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../providers/measurement_provider.dart';
import '../models/measurement.dart';
import '../config/theme.dart';

class MeasurementCreateScreen extends StatefulWidget {
  const MeasurementCreateScreen({super.key});

  @override
  State<MeasurementCreateScreen> createState() => _MeasurementCreateScreenState();
}

class _MeasurementCreateScreenState extends State<MeasurementCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  
  String _selectedIcon = 'monitor_weight';
  String _selectedColor = '0xFF2BEE79';

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'monitor_weight', 'label': 'Peso', 'icon': Symbols.monitor_weight},
    {'name': 'height', 'label': 'Altura', 'icon': Symbols.height},
    {'name': 'favorite', 'label': 'Corazón', 'icon': Symbols.favorite},
    {'name': 'water_drop', 'label': 'Agua', 'icon': Symbols.water_drop},
    {'name': 'local_fire_department', 'label': 'Calorías', 'icon': Symbols.local_fire_department},
    {'name': 'bedtime', 'label': 'Sueño', 'icon': Symbols.bedtime},
    {'name': 'fitness_center', 'label': 'Fitness', 'icon': Symbols.fitness_center},
    {'name': 'monitoring', 'label': 'Monitor', 'icon': Symbols.monitoring},
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
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Medición'),
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
                labelText: 'Nombre',
                hintText: 'Ej: Peso, Presión arterial',
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
            
            // Unit
            TextFormField(
              controller: _unitController,
              decoration: InputDecoration(
                labelText: 'Unidad de medida',
                hintText: 'Ej: kg, cm, bpm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una unidad';
                }
                return null;
              },
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
              onPressed: _saveMeasurement,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.backgroundDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Crear Medición',
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

  void _saveMeasurement() async {
    if (_formKey.currentState!.validate()) {
      final measurementProvider = Provider.of<MeasurementProvider>(
        context,
        listen: false,
      );

      final measurement = Measurement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        icon: _selectedIcon,
        colorHex: _selectedColor,
      );

      await measurementProvider.addMeasurement(measurement);
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
