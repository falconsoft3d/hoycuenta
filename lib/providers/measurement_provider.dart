import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/measurement.dart';
import '../services/measurement_service.dart';

class MeasurementProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  List<Measurement> _measurements = [];

  MeasurementProvider(this.prefs) {
    _loadData();
  }

  List<Measurement> get measurements => _measurements;
  
  List<Measurement> get activeMeasurements =>
      _measurements.where((m) => m.isActive).toList();

  void _loadData() {
    _measurements = MeasurementService.loadMeasurements(prefs);
    notifyListeners();
  }

  Future<void> addMeasurement(Measurement measurement) async {
    await MeasurementService.addMeasurement(prefs, measurement);
    _loadData();
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    await MeasurementService.updateMeasurement(prefs, measurement);
    _loadData();
  }

  Future<void> deleteMeasurement(String measurementId) async {
    await MeasurementService.deleteMeasurement(prefs, measurementId);
    _loadData();
  }

  Future<void> addRecord(String measurementId, MeasurementRecord record) async {
    await MeasurementService.addRecord(prefs, measurementId, record);
    _loadData();
  }

  Future<void> deleteRecord(String measurementId, DateTime date) async {
    await MeasurementService.deleteRecord(prefs, measurementId, date);
    _loadData();
  }

  Measurement? getMeasurementById(String id) {
    try {
      return _measurements.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  MeasurementRecord? getRecordForDate(String measurementId, DateTime date) {
    final measurement = getMeasurementById(measurementId);
    if (measurement == null) return null;

    try {
      return measurement.records.firstWhere(
        (r) => r.date.year == date.year &&
               r.date.month == date.month &&
               r.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}
