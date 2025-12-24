import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/habit_provider.dart';
import '../services/habit_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = 'Usuario';
  bool _isLoading = true;
  bool _isPinEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final prefs = await habitProvider.getPreferences();
    final name = HabitService.getUserName(prefs);
    final pinEnabled = HabitService.isPinEnabled(prefs);
    setState(() {
      _userName = name ?? 'Usuario';
      _isPinEnabled = pinEnabled;
      _isLoading = false;
    });
  }

  Future<void> _showChangeNameDialog() async {
    final controller = TextEditingController(text: _userName);
    
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar nombre'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ingresa tu nombre',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  final habitProvider = Provider.of<HabitProvider>(
                    context,
                    listen: false,
                  );
                  final prefs = await habitProvider.getPreferences();
                  await HabitService.saveUserName(prefs, newName);
                  setState(() {
                    _userName = newName;
                  });
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nombre actualizado correctamente'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _togglePin() async {
    if (_isPinEnabled) {
      // Deshabilitar PIN
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Deshabilitar PIN'),
          content: const Text('¿Deseas desactivar el PIN de seguridad?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final habitProvider = Provider.of<HabitProvider>(
                  context,
                  listen: false,
                );
                final prefs = await habitProvider.getPreferences();
                await HabitService.disablePin(prefs);
                setState(() {
                  _isPinEnabled = false;
                });
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN deshabilitado')),
                  );
                }
              },
              child: const Text('Deshabilitar'),
            ),
          ],
        ),
      );
    } else {
      // Habilitar PIN
      final result = await Navigator.pushNamed(context, '/pin-setup');
      if (result == true) {
        setState(() {
          _isPinEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN configurado correctamente')),
          );
        }
      }
    }
  }

  Future<void> _changePin() async {
    final result = await Navigator.pushNamed(context, '/pin-setup');
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN actualizado')),
      );
    }
  }

  Future<void> _showDeleteDataDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Borrar todos los datos'),
          content: const Text(
            '¿Estás seguro de que deseas borrar todos tus datos? '
            'Esta acción no se puede deshacer y perderás todos tus hábitos y progreso.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final habitProvider = Provider.of<HabitProvider>(
                  context,
                  listen: false,
                );
                final prefs = await habitProvider.getPreferences();
                
                // Borrar todos los datos
                await prefs.clear();
                
                if (mounted) {
                  Navigator.pop(context);
                  // Navegar al onboarding
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/onboarding',
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Borrar todo',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 8),
                // Sección de Usuario
                _buildSection(
                  'Usuario',
                  [
                    _buildListTile(
                      icon: Icons.person,
                      title: 'Nombre',
                      subtitle: _userName,
                      onTap: _showChangeNameDialog,
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sección de Seguridad
                _buildSection(
                  'Seguridad',
                  [
                    _buildListTile(
                      icon: Icons.lock_outline,
                      title: 'PIN de seguridad',
                      subtitle: _isPinEnabled ? 'Activado' : 'Desactivado',
                      onTap: _togglePin,
                      isDark: isDark,
                      trailing: Switch(
                        value: _isPinEnabled,
                        onChanged: (_) => _togglePin(),
                        activeColor: AppTheme.primary,
                      ),
                    ),
                    if (_isPinEnabled)
                      _buildListTile(
                        icon: Icons.edit,
                        title: 'Cambiar PIN',
                        subtitle: 'Modifica tu PIN actual',
                        onTap: _changePin,
                        isDark: isDark,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sección de Datos
                _buildSection(
                  'Datos',
                  [
                    _buildListTile(
                      icon: Icons.delete_forever,
                      title: 'Borrar todos los datos',
                      subtitle: 'Elimina todos los hábitos y configuraciones',
                      onTap: _showDeleteDataDialog,
                      isDark: isDark,
                      textColor: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Sección de Información
                _buildSection(
                  'Información',
                  [
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'Versión',
                      subtitle: '1.0.0',
                      onTap: null,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required bool isDark,
    Color? textColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? AppTheme.primary).withAlpha(26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppTheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: textColor?.withAlpha(179) ??
              (isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight),
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                )
              : null),
      onTap: onTap,
    );
  }
}
