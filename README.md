# HoyCuenta - Control de Hábitos 🎯

Una aplicación Flutter moderna para el seguimiento de hábitos diarios con visualización tipo GitHub (heatmap).

## 🌟 Características

- 🎉 **Onboarding personalizado** en el primer inicio (nombre y selección de hábitos)
- ✅ **Dashboard interactivo** con resumen diario, racha actual y saludo personalizado
- 📊 **Calendario heatmap** tipo GitHub para visualizar tu progreso mensual
- ⚙️ **Configuración de hábitos** con iconos personalizados y frecuencias (diaria, semanal, mensual)
- 📈 **Estadísticas detalladas** por hábito (racha actual, porcentaje de cumplimiento)
- 💾 **Almacenamiento local** usando SharedPreferences
- 🌙 **Tema oscuro** con color primario verde (#2BEE79)
- 🎨 **UI moderna** basada en Material Design 3

## 📱 Pantallas

1. **Onboarding** (solo primera vez):
   - Página de bienvenida con características de la app
   - Solicitud de nombre de usuario
   - Selección de hábitos iniciales (8 opciones predefinidas)
   
2. **Dashboard**: Vista principal con resumen del día, calendario heatmap y lista de metas activas

3. **Configuración de Metas**: Gestión de hábitos con formulario para agregar/editar

4. **Detalle de Meta**: Vista individual con estadísticas, historial y botón de completar

5. **Configuración**: Ajustes personales
   - Cambiar nombre de usuario
   - Borrar todos los datos
   - Información de la app

## 🚀 Ejecutar la Aplicación

### Requisitos previos
- Flutter SDK (3.10.3 o superior)
- Dart SDK
- Un emulador o dispositivo físico

### Instalación

1. **Instalar dependencias**:
```bash
flutter pub get
```

2. **Ejecutar en modo debug**:
```bash
flutter run
```

3. **Ejecutar en iOS**:
```bash
flutter run -d ios
```

4. **Ejecutar en Android**:
```bash
flutter run -d android
```

## 📦 Dependencias Principales

- `provider: ^6.1.1` - Gestión de estado
- `shared_preferences: ^2.2.2` - Almacenamiento local
- `intl: ^0.19.0` - Internacionalización y formato de fechas
- `fl_chart: ^0.66.0` - Gráficos
- `material_symbols_icons: ^4.2719.3` - Iconos Material Symbols

## 🏗️ Estructura del Proyecto

```
lib/
├── config/
│   └── theme.dart              # Temas y constantes de diseño
├── models/
│   └── habit.dart              # Modelos de datos
├── providers/
│   └── habit_provider.dart     # Provider para gestión de estado
├── services/
│   └── habit_service.dart      # Servicio de almacenamiento local
├── screens/
│   ├── dashboard_screen.dart       # Pantalla principal
│   ├── habits_config_screen.dart   # Configuración de hábitos
│   ├── habit_detail_screen.dart    # Detalle individual
│   ├── onboarding_screen.dart      # Experiencia de primer inicio
│   └── settings_screen.dart        # Configuración y ajustes
└── main.dart                   # Punto de entrada
```

## 🔄 Últimas Actualizaciones

### Configuración y Logo (Diciembre 2024)
- ⚙️ Nueva pantalla de Configuración con opciones de:
  - Cambiar nombre de usuario
  - Borrar todos los datos de la app
  - Información de versión
- 🎨 Logo personalizado configurado para iOS y Android
- 🔧 Optimización del flujo de onboarding (se obtiene SharedPreferences una sola vez)
- 🔗 Botón de configuración conectado en el dashboard

### Implementación de Onboarding (Diciembre 2024)
- ✨ Añadida experiencia de primer inicio con onboarding de 3 páginas
- 🗑️ Eliminados datos de ejemplo precargados
- 👤 Solicitud y almacenamiento del nombre del usuario
- 🎯 Selección de hábitos iniciales en onboarding
- 💬 Dashboard ahora muestra saludo personalizado con nombre del usuario
- 🔧 Mejoras en `HabitService` para gestionar datos de usuario y estado de onboarding

## 🎨 Paleta de Colores

- **Primary**: `#2BEE79` (Verde brillante)
- **Background Dark**: `#102217` (Verde oscuro profundo)
- **Surface Dark**: `#162E21` (Verde oscuro para tarjetas)
- **Text Secondary Dark**: `#9DB9A8` (Gris verdoso)

---

Desarrollado con ❤️ usando Flutter
