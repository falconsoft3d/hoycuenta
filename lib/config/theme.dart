import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color primary = Color(0xFF2BEE79);
  static const Color primaryHover = Color(0xFF25D068);
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF102217);
  static const Color surfaceDark = Color(0xFF162E21);
  static const Color surfaceCard = Color(0xFF1C3829);
  static const Color surfaceInput = Color(0xFF0C1A12);
  
  // Colores de texto
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF9DB9A8);

  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primary,
      surface: Colors.white,
      onPrimary: backgroundDark,
      onSurface: Colors.black87,
      secondary: primary,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withAlpha(13)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: backgroundDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  // Tema oscuro
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surfaceDark,
      onPrimary: backgroundDark,
      onSurface: Colors.white,
      secondary: primary,
    ),
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withAlpha(13)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withAlpha(26)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withAlpha(26)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: backgroundDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );
}

// Iconos predefinidos para hábitos
class HabitIcons {
  static const List<Map<String, dynamic>> icons = [
    {'icon': 'local_drink', 'color': 0xFF3B82F6, 'name': 'Agua'}, // Blue
    {'icon': 'menu_book', 'color': 0xFF8B5CF6, 'name': 'Lectura'}, // Purple
    {'icon': 'directions_run', 'color': 0xFFF97316, 'name': 'Ejercicio'}, // Orange
    {'icon': 'self_improvement', 'color': 0xFF10B981, 'name': 'Meditación'}, // Green
    {'icon': 'restaurant', 'color': 0xFFEF4444, 'name': 'Comida'}, // Red
    {'icon': 'bedtime', 'color': 0xFF6366F1, 'name': 'Sueño'}, // Indigo
    {'icon': 'music_note', 'color': 0xFFEC4899, 'name': 'Música'}, // Pink
    {'icon': 'brush', 'color': 0xFFF59E0B, 'name': 'Arte'}, // Amber
    {'icon': 'code', 'color': 0xFF06B6D4, 'name': 'Programación'}, // Cyan
    {'icon': 'fitness_center', 'color': 0xFFDC2626, 'name': 'Gimnasio'}, // Red
    {'icon': 'spa', 'color': 0xFF14B8A6, 'name': 'Spa'}, // Teal
    {'icon': 'school', 'color': 0xFF2563EB, 'name': 'Estudio'}, // Blue
  ];
}
