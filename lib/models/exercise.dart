class Exercise {
  final String id;
  final String name;
  final int defaultSets; // Tandas por defecto
  final int defaultReps; // Repeticiones por defecto
  final String icon;
  final String colorHex;
  final bool isActive;
  final List<ExerciseSession> sessions;

  Exercise({
    required this.id,
    required this.name,
    required this.defaultSets,
    required this.defaultReps,
    required this.icon,
    required this.colorHex,
    this.isActive = true,
    List<ExerciseSession>? sessions,
  }) : sessions = sessions ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'defaultSets': defaultSets,
      'defaultReps': defaultReps,
      'icon': icon,
      'colorHex': colorHex,
      'isActive': isActive,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      defaultSets: json['defaultSets'] as int,
      defaultReps: json['defaultReps'] as int,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
      isActive: json['isActive'] as bool? ?? true,
      sessions: (json['sessions'] as List?)
          ?.map((s) => ExerciseSession.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Exercise copyWith({
    String? name,
    int? defaultSets,
    int? defaultReps,
    String? icon,
    String? colorHex,
    bool? isActive,
    List<ExerciseSession>? sessions,
  }) {
    return Exercise(
      id: id,
      name: name ?? this.name,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      sessions: sessions ?? this.sessions,
    );
  }
}

class ExerciseSession {
  final DateTime date;
  final int completedSets;
  final int targetSets;
  final int completedReps; // Total de repeticiones completadas
  final int targetReps; // Total de repeticiones objetivo
  final int totalSeconds; // Tiempo total de la sesión en segundos
  final List<SetRecord> setRecords; // Detalle de cada tanda

  ExerciseSession({
    required this.date,
    required this.completedSets,
    required this.targetSets,
    required this.completedReps,
    required this.targetReps,
    this.totalSeconds = 0,
    List<SetRecord>? setRecords,
  }) : setRecords = setRecords ?? [];

  double get completionPercentage {
    if (targetReps == 0) return 0;
    return (completedReps / targetReps) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'completedSets': completedSets,
      'targetSets': targetSets,
      'completedReps': completedReps,
      'targetReps': targetReps,
      'totalSeconds': totalSeconds,
      'setRecords': setRecords.map((s) => s.toJson()).toList(),
    };
  }

  factory ExerciseSession.fromJson(Map<String, dynamic> json) {
    return ExerciseSession(
      date: DateTime.parse(json['date'] as String),
      completedSets: json['completedSets'] as int,
      targetSets: json['targetSets'] as int,
      completedReps: json['completedReps'] as int,
      targetReps: json['targetReps'] as int,
      totalSeconds: json['totalSeconds'] as int? ?? 0,
      setRecords: (json['setRecords'] as List?)
          ?.map((s) => SetRecord.fromJson(s as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class SetRecord {
  final int setNumber;
  final int completedReps;
  final int targetReps;
  final int secondsPerRep; // Segundos por repetición
  final int totalSeconds; // Segundos totales de esta tanda

  SetRecord({
    required this.setNumber,
    required this.completedReps,
    required this.targetReps,
    this.secondsPerRep = 0,
    this.totalSeconds = 0,
  });

  bool get isComplete => completedReps >= targetReps;

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'completedReps': completedReps,
      'targetReps': targetReps,
      'secondsPerRep': secondsPerRep,
      'totalSeconds': totalSeconds,
    };
  }

  factory SetRecord.fromJson(Map<String, dynamic> json) {
    return SetRecord(
      setNumber: json['setNumber'] as int,
      completedReps: json['completedReps'] as int,
      targetReps: json['targetReps'] as int,
      secondsPerRep: json['secondsPerRep'] as int? ?? 0,
      totalSeconds: json['totalSeconds'] as int? ?? 0,
    );
  }
}
