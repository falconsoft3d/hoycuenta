import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../providers/measurement_provider.dart';
import '../models/measurement.dart';
import '../config/theme.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final measurementProvider = Provider.of<MeasurementProvider>(context);
    final measurements = measurementProvider.activeMeasurements;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mediciones'),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      ),
      body: measurements.isEmpty
          ? _buildEmptyState(context, isDark)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements[index];
                return _buildMeasurementCard(context, measurement, isDark);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/measurement-create');
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
            Symbols.monitoring,
            size: 80,
            color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes mediciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea una medición para comenzar',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard(
    BuildContext context,
    Measurement measurement,
    bool isDark,
  ) {
    final latestRecord = measurement.records.isNotEmpty
        ? measurement.records.last
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/measurement-detail',
          arguments: measurement,
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
                color: Color(int.parse(measurement.colorHex)).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(measurement.icon),
                color: Color(int.parse(measurement.colorHex)),
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
                    measurement.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    latestRecord != null
                        ? 'Último: ${latestRecord.value} ${measurement.unit}'
                        : 'Sin registros',
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
            // Arrow
            Icon(
              Symbols.chevron_right,
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'monitor_weight':
        return Symbols.monitor_weight;
      case 'height':
        return Symbols.height;
      case 'favorite':
        return Symbols.favorite;
      case 'water_drop':
        return Symbols.water_drop;
      case 'local_fire_department':
        return Symbols.local_fire_department;
      case 'bedtime':
        return Symbols.bedtime;
      case 'fitness_center':
        return Symbols.fitness_center;
      default:
        return Symbols.monitoring;
    }
  }
}
