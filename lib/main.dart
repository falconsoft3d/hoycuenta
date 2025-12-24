import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/theme.dart';
import 'services/habit_service.dart';
import 'providers/habit_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/habits_config_screen.dart';
import 'screens/habit_detail_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/pin_screen.dart';
import 'models/habit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar localización en español
  await initializeDateFormatting('es', null);
  
  // Configurar barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final habitService = HabitService(prefs);

  runApp(MyApp(habitService: habitService, prefs: prefs));
}

class MyApp extends StatelessWidget {
  final HabitService habitService;
  final SharedPreferences prefs;

  const MyApp({super.key, required this.habitService, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Verificar si es la primera vez
    final isFirstTime = !HabitService.isOnboardingCompleted(prefs);
    final isPinEnabled = HabitService.isPinEnabled(prefs) && !isFirstTime;
    
    return ChangeNotifierProvider(
      create: (_) => HabitProvider(habitService, prefs),
      child: MaterialApp(
        title: 'HoyCuenta - Control de Hábitos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Siempre usar tema oscuro por defecto
        home: isFirstTime
            ? const OnboardingScreen()
            : (isPinEnabled
                ? const PinScreen(isSetup: false)
                : const DashboardScreen()),
        onGenerateRoute: (settings) {
          // Manejo de rutas
          switch (settings.name) {
            case '/habits-config':
              return MaterialPageRoute(
                builder: (_) => const HabitsConfigScreen(),
              );
            case '/habit-detail':
              final habit = settings.arguments as Habit;
              return MaterialPageRoute(
                builder: (_) => HabitDetailScreen(habit: habit),
              );
            case '/settings':
              return MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              );
            case '/onboarding':
              return MaterialPageRoute(
                builder: (_) => const OnboardingScreen(),
              );
            case '/pin':
              return MaterialPageRoute(
                builder: (_) => const PinScreen(isSetup: false),
              );
            case '/pin-setup':
              return MaterialPageRoute(
                builder: (_) => const PinScreen(isSetup: true),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              );
          }
        },
      ),
    );
  }
}
