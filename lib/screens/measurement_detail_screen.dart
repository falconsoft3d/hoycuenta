import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/measurement_provider.dart';
import '../models/measurement.dart';
import '../config/theme.dart';

class MeasurementDetailScreen extends StatefulWidget {
  final Measurement measurement;

  const MeasurementDetailScreen({super.key, required this.measurement});

  @override
  State<MeasurementDetailScreen> createState() => _MeasurementDetailScreenState();
}

class _MeasurementDetailScreenState extends State<MeasurementDetailScreen> {
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final measurementProvider = Provider.of<MeasurementProvider>(context);
    final measurement = measurementProvider.getMeasurementById(widget.measurement.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (measurement == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Medición')),
        body: const Center(child: Text('Medición no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(measurement.name),
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        actions: [
          IconButton(
            icon: const Icon(Symbols.delete),
            onPressed: () => _showDeleteDialog(context, measurement),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Add Record Card
          _buildAddRecordCard(context, measurement, isDark),
          const SizedBox(height: 16),
          
          // Chart
          if (measurement.records.isNotEmpty) ...[
            _buildChartCard(context, measurement, isDark),
            const SizedBox(height: 16),
          ],
          
          // Statistics
          if (measurement.records.isNotEmpty) ...[
            _buildStatisticsCard(context, measurement, isDark),
            const SizedBox(height: 16),
          ],
          
          // Records List
          _buildRecordsList(context, measurement, isDark),
        ],
      ),
    );
  }

  Widget _buildAddRecordCard(
    BuildContext context,
    Measurement measurement,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(measurement.colorHex)).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconData(measurement.icon),
                  color: Color(int.parse(measurement.colorHex)),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Agregar registro de hoy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _valueController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    suffixText: measurement.unit,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _addRecord(context, measurement),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.backgroundDark,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context,
    Measurement measurement,
    bool isDark,
  ) {
    final records = measurement.records;
    if (records.isEmpty) return const SizedBox.shrink();

    // Tomar los últimos 30 registros
    final displayRecords = records.length > 30
        ? records.sublist(records.length - 30)
        : records;

    final spots = displayRecords
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
        .toList();

    final minY = displayRecords.map((r) => r.value).reduce((a, b) => a < b ? a : b);
    final maxY = displayRecords.map((r) => r.value).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

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
            'Progreso',
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
                  horizontalInterval: 1,
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
                      interval: (displayRecords.length / 5).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < displayRecords.length) {
                          final record = displayRecords[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('d/M').format(record.date),
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
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
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
                minY: minY - padding,
                maxY: maxY + padding,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Color(int.parse(measurement.colorHex)),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(int.parse(measurement.colorHex)),
                          strokeWidth: 2,
                          strokeColor: isDark ? AppTheme.surfaceDark : Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(int.parse(measurement.colorHex)).withOpacity(0.1),
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

  Widget _buildStatisticsCard(
    BuildContext context,
    Measurement measurement,
    bool isDark,
  ) {
    final records = measurement.records;
    if (records.isEmpty) return const SizedBox.shrink();

    final values = records.map((r) => r.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final avg = values.reduce((a, b) => a + b) / values.length;
    final latest = values.last;

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
                child: _buildStatItem('Actual', latest, measurement.unit, isDark),
              ),
              Expanded(
                child: _buildStatItem('Promedio', avg, measurement.unit, isDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Mínimo', min, measurement.unit, isDark),
              ),
              Expanded(
                child: _buildStatItem('Máximo', max, measurement.unit, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double value, String unit, bool isDark) {
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
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList(
    BuildContext context,
    Measurement measurement,
    bool isDark,
  ) {
    final records = List<MeasurementRecord>.from(measurement.records.reversed);

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
            'Historial',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (records.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No hay registros aún',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                ),
              ),
            )
          else
            ...records.take(10).map((record) {
              return Dismissible(
                key: Key(record.date.toIso8601String()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  _deleteRecord(context, measurement, record.date);
                },
                child: Container(
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
                      Text(
                        DateFormat('EEEE, d MMM yyyy', 'es').format(record.date),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        '${record.value} ${measurement.unit}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(measurement.colorHex)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _addRecord(BuildContext context, Measurement measurement) async {
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un valor válido')),
      );
      return;
    }

    final measurementProvider = Provider.of<MeasurementProvider>(
      context,
      listen: false,
    );

    final record = MeasurementRecord(
      date: DateTime.now(),
      value: value,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
    );

    await measurementProvider.addRecord(measurement.id, record);
    _valueController.clear();
    _noteController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro agregado')),
      );
    }
  }

  void _deleteRecord(
    BuildContext context,
    Measurement measurement,
    DateTime date,
  ) async {
    final measurementProvider = Provider.of<MeasurementProvider>(
      context,
      listen: false,
    );

    await measurementProvider.deleteRecord(measurement.id, date);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado')),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, Measurement measurement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar medición'),
        content: Text('¿Estás seguro de eliminar "${measurement.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final measurementProvider = Provider.of<MeasurementProvider>(
                context,
                listen: false,
              );
              await measurementProvider.deleteMeasurement(measurement.id);
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
