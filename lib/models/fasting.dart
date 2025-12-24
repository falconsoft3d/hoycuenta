class FastingSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes; // Duración en minutos
  final bool isActive;

  FastingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'isActive': isActive,
    };
  }

  factory FastingSession.fromJson(Map<String, dynamic> json) {
    return FastingSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  FastingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    bool? isActive,
  }) {
    return FastingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
    );
  }
}
