# 🎯 HoyCuenta - App de Control de Hábitos

## ✅ Proyecto Completado

He creado una aplicación Flutter completa de control de hábitos con las siguientes características:

### 📱 Pantallas Implementadas

1. **Dashboard (Pantalla Principal)**
   - Resumen del día con porcentaje de completado
   - Racha actual con fuego 🔥
   - Calendario heatmap tipo GitHub (muestra actividad mensual)
   - Lista de metas activas
   - Botón flotante para agregar nuevas metas

2. **Configuración de Hábitos**
   - Lista de todos los hábitos
   - Modal para agregar/editar hábitos
   - Selección de icono (12 opciones con colores)
   - Frecuencia: Diaria, Semanal, Mensual
   - Opción para eliminar hábitos

3. **Detalle de Hábito**
   - Tarjeta de progreso del día
   - Estadísticas: racha actual y % de cumplimiento
   - Calendario mensual interactivo
   - Historial completo del hábito
   - Marcar/desmarcar como completado

### 🎨 Diseño

- **Tema oscuro** basado en tu diseño adjunto
- Color primario: `#2BEE79` (verde brillante)
- Fondo oscuro: `#102217` (verde oscuro profundo)
- Iconos Material Symbols
- Animaciones y transiciones suaves

### 💾 Características Técnicas

- Almacenamiento local con `SharedPreferences`
- Gestión de estado con `Provider`
- Datos de ejemplo precargados
- Calendario interactivo tipo GitHub
- Internacionalización en español
- Soporte multiplataforma (iOS, Android, Web, macOS, Windows, Linux)

### 📊 Funcionalidades

✅ Agregar/editar/eliminar hábitos
✅ Marcar hábitos como completados
✅ Ver historial en calendario tipo GitHub
✅ Calcular rachas automáticamente
✅ Estadísticas de cumplimiento
✅ 12 iconos predefinidos con colores
✅ 3 frecuencias: diaria, semanal, mensual
✅ Resumen diario con porcentaje
✅ Datos persistentes entre sesiones

### 🚀 Para Ejecutar

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en iOS
flutter run -d ios

# Ejecutar en Android
flutter run -d android

# Ejecutar en macOS
flutter run -d macos

# Ejecutar en Web
flutter run -d chrome
```

### 📂 Estructura del Proyecto

```
lib/
├── config/
│   └── theme.dart              # Temas y colores
├── models/
│   └── habit.dart              # Modelos de datos
├── providers/
│   └── habit_provider.dart     # Gestión de estado
├── services/
│   └── habit_service.dart      # Almacenamiento local
├── screens/
│   ├── dashboard_screen.dart   # Pantalla principal
│   ├── habits_config_screen.dart
│   └── habit_detail_screen.dart
├── utils/
│   └── sample_data.dart        # Datos de ejemplo
└── main.dart
```

### 🎯 Datos de Ejemplo

La app viene con 5 hábitos de ejemplo:
1. **Beber 2L de agua** (Diario)
2. **Leer 30 mins** (Diario)
3. **Correr 5km** (Semanal)
4. **Meditar 10 mins** (Diario)
5. **Programar 2 horas** (Diario)

Con historial de los últimos 25 días para que puedas ver el heatmap en acción.

### ✨ Lo Mejor de la App

- **Heatmap tipo GitHub**: Visualización clara de tu consistencia
- **Interfaz intuitiva**: Basada exactamente en tu diseño
- **Tema oscuro elegante**: Verde brillante sobre fondo oscuro
- **Datos persistentes**: Todo se guarda localmente
- **Estadísticas automáticas**: Racha y % de cumplimiento
- **Sin internet requerido**: Funciona 100% offline

---

¡La app está lista para usar! 🚀
