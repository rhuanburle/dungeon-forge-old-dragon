// theme/app_colors.dart

import 'package:flutter/material.dart';

/// Cores do tema Old Dragon: Vermelho, Preto e Branco
class AppColors {
  // Cores principais do Old Dragon
  static const Color primary = Color(0xFFDC2626); // Red 600 - Vermelho Old Dragon
  static const Color primaryLight = Color(0xFFEF4444); // Red 500 - Vermelho mais claro
  static const Color primaryDark = Color(0xFFB91C1C); // Red 700 - Vermelho mais escuro
  
  // Cores de fundo (Preto)
  static const Color background = Color(0xFF000000); // Preto puro
  static const Color surface = Color(0xFF0A0A0A); // Preto suave
  static const Color surfaceLight = Color(0xFF1A1A1A); // Preto médio
  static const Color surfaceDark = Color(0xFF2A2A2A); // Preto claro
  
  // Cores de texto (Branco)
  static const Color textPrimary = Colors.white; // Branco puro
  static const Color textSecondary = Color(0xFFE5E5E5); // Branco suave
  static const Color textTertiary = Color(0xFFCCCCCC); // Branco médio
  
  // Cores de borda
  static const Color border = Color(0xFF404040); // Cinza escuro
  static const Color borderLight = Color(0xFF606060); // Cinza médio
  static const Color borderAccent = Color(0xFFDC2626); // Vermelho para bordas especiais
  
  // Cores de estado
  static const Color success = Color(0xFF10B981); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  
  // Cores de interação
  static const Color hover = Color(0xFF2A2A2A); // Cinza escuro para hover
  static const Color selected = Color(0xFFDC2626); // Vermelho para seleção
  static const Color active = Color(0xFFDC2626); // Vermelho para elementos ativos
}
