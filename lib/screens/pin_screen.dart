import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/habit_provider.dart';
import '../services/habit_service.dart';
import 'dashboard_screen.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup; // true para configurar nuevo PIN, false para verificar

  const PinScreen({super.key, this.isSetup = false});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  _getTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  _getSubtitle(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // PIN Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final currentPin = _isConfirming ? _confirmPin : _pin;
                    final isFilled = index < currentPin.length;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFilled
                            ? AppTheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: isFilled
                              ? AppTheme.primary
                              : (isDark ? Colors.white54 : Colors.grey),
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
                
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
                
                const SizedBox(height: 60),
                
                // Number Pad
                _buildNumberPad(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (widget.isSetup) {
      return _isConfirming ? 'Confirma tu PIN' : 'Configura tu PIN';
    }
    return 'Ingresa tu PIN';
  }

  String _getSubtitle() {
    if (widget.isSetup) {
      return _isConfirming
          ? 'Ingresa el PIN nuevamente'
          : 'Crea un PIN de 4 dígitos';
    }
    return 'Desbloquea la aplicación';
  }

  Widget _buildNumberPad(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('1', isDark),
            _buildNumberButton('2', isDark),
            _buildNumberButton('3', isDark),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('4', isDark),
            _buildNumberButton('5', isDark),
            _buildNumberButton('6', isDark),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('7', isDark),
            _buildNumberButton('8', isDark),
            _buildNumberButton('9', isDark),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 80, height: 80), // Empty space
            _buildNumberButton('0', isDark),
            _buildDeleteButton(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number, bool isDark) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? Colors.white.withAlpha(13)
                : Colors.black.withAlpha(13),
          ),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(bool isDark) {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number) async {
    setState(() {
      _errorMessage = '';
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          _confirmPin += number;
          if (_confirmPin.length == 4) {
            _verifyConfirmation();
          }
        }
      } else {
        if (_pin.length < 4) {
          _pin += number;
          if (_pin.length == 4) {
            if (widget.isSetup) {
              setState(() {
                _isConfirming = true;
              });
            } else {
              _verifyPin();
            }
          }
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      _errorMessage = '';
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _verifyConfirmation() async {
    if (_pin == _confirmPin) {
      // Guardar PIN
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      final prefs = await habitProvider.getPreferences();
      await HabitService.savePin(prefs, _pin);
      
      if (mounted) {
        // Regresar a la pantalla anterior (Settings)
        Navigator.of(context).pop(true);
      }
    } else {
      setState(() {
        _errorMessage = 'Los PIN no coinciden';
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final prefs = await habitProvider.getPreferences();
    final savedPin = HabitService.getPin(prefs);
    
    if (_pin == savedPin) {
      if (mounted) {
        // Navegar al dashboard reemplazando la pantalla actual
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'PIN incorrecto';
        _pin = '';
      });
    }
  }
}
