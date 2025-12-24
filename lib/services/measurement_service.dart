import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/measurement.dart';

class MeasurementService {
  static const String _measurementsKey = 'measurements';

  static List<Measurement> loadMeasurements(SharedPreferences prefs) {
    final jsonString = prefs.getString(_measurementsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Measurement.fromJson(json)).toList();
  }

  static Future<void> saveMeasurements(
    SharedPreferences prefs,
    List<Measurement> measurements,
  ) async {
    final jsonString = json.encode(
      measurements.map((m) => m.toJson()).toList(),
    );
    await prefs.setString(_measurementsKey, jsonString);
  }

  static Future<void> addMeasurement(
    SharedPreferences prefs,
    Measurement measurement,
  ) async {
    final measurements = loadMeasurements(prefs);
    measurements.add(measurement);
    await saveMeasurements(prefs, measurements);
  }

  static Future<void> updateMeasurement(
    SharedPreferences prefs,
    Measurement updatedMeasurement,
  ) async {
    final measurements = loadMeasurements(prefs);
    final index = measurements.indexWhere((m) => m.id == updatedMeasurement.id);
    if (index != -1) {
      measurements[index] = updatedMeasurement;
      await saveMeasurements(prefs, measurements);
    }
  }

  static Future<void> deleteMeasurement(
    SharedPreferences prefs,
    String measurementId,
  ) async {
    final measurements = loadMeasurements(prefs);
    measurements.removeWhere((m) => m.id == measurementId);
    await saveMeasurements(prefs, measurements);
  }

  static Future<void> addRecord(
    SharedPreferences prefs,
    String measurementId,
    MeasurementRecord record,
  ) async {
    final measurements = loadMeasurements(prefs);
    final index = measurements.indexWhere((m) => m.id == measurementId);
    if (index != -1) {
      final measurement = measurements[index];
      final updatedRecords = List<MeasurementRecord>.from(measurement.records);
      
      // Reemplazar si ya existe un registro para esta fecha
      final existingIndex = updatedRecords.indexWhere(
        (r) => r.date.year == record.date.year &&
               r.date.month == record.date.month &&
               r.date.day == record.date.day,
      );
      
      if (existingIndex != -1) {
        updatedRecords[existingIndex] = record;
      } else {
        updatedRecords.add(record);
      }
      
      // Ordenar por fecha
      updatedRecords.sort((a, b) => a.date.compareTo(b.date));
      
      measurements[index] = measurement.copyWith(records: updatedRecords);
      await saveMeasurements(prefs, measurements);
    }
  }

  static Future<void> deleteRecord(
    SharedPreferences prefs,
    String measurementId,
    DateTime date,
  ) async {
    final measurements = loadMeasurements(prefs);
    final index = measurements.indexWhere((m) => m.id == measurementId);
    if (index != -1) {
      final measurement = measurements[index];
      final updatedRecords = measurement.records.where(
        (r) => !(r.date.year == date.year &&
                 r.date.month == date.month &&
                 r.date.day == date.day),
      ).toList();
      
      measurements[index] = measurement.copyWith(records: updatedRecords);
      await saveMeasurements(prefs, measurements);
    }
  }
}
