// theme/app_colors.dart

import 'package:flutter/material.dart';

/// Cores suaves para o tema da aplicação
class AppColors {
  // Cores principais (substituindo amber)
  static const Color primary = Color(0xFF6B7280); // Grey 500
  static const Color primaryLight = Color(0xFF9CA3AF); // Grey 400
  static const Color primaryDark = Color(0xFF4B5563); // Grey 600

  // Cores de fundo
  static const Color background = Color(0xFF0d0d0d);
  static const Color surface = Color(0xFF1a1a1a);
  static const Color surfaceLight = Color(0xFF2a2a2a);
  static const Color surfaceDark = Color(0xFF3a3a3a);

  // Cores de texto
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF); // Grey 400
  static const Color textTertiary = Color(0xFF6B7280); // Grey 500

  // Cores de borda
  static const Color border = Color(0xFF4B5563); // Grey 600
  static const Color borderLight = Color(0xFF6B7280); // Grey 500

  // Cores de estado
  static const Color success = Color(0xFF10B981); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500

  // Cores de interação
  static const Color hover = Color(0xFF374151); // Grey 700
  static const Color selected = Color(0xFF4B5563); // Grey 600
}
