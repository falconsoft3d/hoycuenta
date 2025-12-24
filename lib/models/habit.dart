// Modelo de hábito
class Habit {
  final String id;
  final String name;
  final String? description;
  final HabitFrequency frequency;
  final String icon;
  final String colorHex;
  final DateTime createdAt;
  bool isActive;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.icon,
    required this.colorHex,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency.name,
      'icon': icon,
      'colorHex': colorHex,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
      ),
      icon: json['icon'],
      colorHex: json['colorHex'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    HabitFrequency? frequency,
    String? icon,
    String? colorHex,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Frecuencia del hábito
enum HabitFrequency {
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case HabitFrequency.daily:
        return 'Diaria';
      case HabitFrequency.weekly:
        return 'Semanal';
      case HabitFrequency.monthly:
        return 'Mensual';
    }
  }

  String get iconName {
    switch (this) {
      case HabitFrequency.daily:
        return 'repeat';
      case HabitFrequency.weekly:
        return 'repeat';
      case HabitFrequency.monthly:
        return 'calendar_month';
    }
  }
}

// Modelo de cumplimiento de hábito para un día específico
class HabitCompletion {
  final String habitId;
  final DateTime date;
  final bool completed;
  final int? progress; // Opcional, para hábitos con progreso (ej: 1500ml de 2000ml)
  final int? target; // Meta del día

  HabitCompletion({
    required this.habitId,
    required this.date,
    required this.completed,
    this.progress,
    this.target,
  });

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'date': _dateOnly(date).toIso8601String(),
      'completed': completed,
      'progress': progress,
      'target': target,
    };
  }

  factory HabitCompletion.fromJson(Map<String, dynamic> json) {
    return HabitCompletion(
      habitId: json['habitId'],
      date: DateTime.parse(json['date']),
      completed: json['completed'],
      progress: json['progress'],
      target: json['target'],
    );
  }

  // Helper para obtener solo la fecha sin hora
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  HabitCompletion copyWith({
    String? habitId,
    DateTime? date,
    bool? completed,
    int? progress,
    int? target,
  }) {
    return HabitCompletion(
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      progress: progress ?? this.progress,
      target: target ?? this.target,
    );
  }
}

// Helper para generar fecha sin hora
DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
