class Measurement {
  final String id;
  final String name;
  final String unit; // kg, cm, etc.
  final String icon;
  final String colorHex;
  final bool isActive;
  final List<MeasurementRecord> records;

  Measurement({
    required this.id,
    required this.name,
    required this.unit,
    required this.icon,
    required this.colorHex,
    this.isActive = true,
    List<MeasurementRecord>? records,
  }) : records = records ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'icon': icon,
      'colorHex': colorHex,
      'isActive': isActive,
      'records': records.map((r) => r.toJson()).toList(),
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
      isActive: json['isActive'] as bool? ?? true,
      records: (json['records'] as List?)
          ?.map((r) => MeasurementRecord.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  Measurement copyWith({
    String? name,
    String? unit,
    String? icon,
    String? colorHex,
    bool? isActive,
    List<MeasurementRecord>? records,
  }) {
    return Measurement(
      id: id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      records: records ?? this.records,
    );
  }
}

class MeasurementRecord {
  final DateTime date;
  final double value;
  final String? note;

  MeasurementRecord({
    required this.date,
    required this.value,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
      'note': note,
    };
  }

  factory MeasurementRecord.fromJson(Map<String, dynamic> json) {
    return MeasurementRecord(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }
}
