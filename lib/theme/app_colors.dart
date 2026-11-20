import 'package:flutter/material.dart';

/// Paleta do app — cores extraídas das capturas do app de referência.
class AppColors {
  AppColors._();

  // Marca
  static const primary = Color(0xFF3F6FB5); // azul do header, títulos e "Média"
  static const primaryDark = Color(0xFF2F5A99);
  static const primarySoft = Color(0xFFE3ECF8); // indicador da bottom bar

  // Superfícies
  static const background = Color(0xFFFAFAFA); // fundo das telas
  static const surface = Color(0xFFF0F1F3); // cards cinza
  static const surfaceHigh = Color(0xFFE6E8EB); // pill do seletor / pressionado
  static const white = Colors.white;

  // Texto
  static const textPrimary = Color(0xFF3A3A3A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textMuted = Color(0xFF9A9A9A);

  // Status de faltas
  static const success = Color(0xFF3E9B5F); // 0–70%
  static const warning = Color(0xFFD9A13A); // 71–100%
  static const danger = Color(0xFFAB3529); // acima do limite
  static const progressTrack = Color(0xFFFAFAFA);

  // Banner
  static const gold = Color(0xFFC8AA74);

  /// Gradientes dos banners promocionais (chave = campo "palette" do JSON).
  static const Map<String, List<Color>> bannerPalettes = {
    'night': [Color(0xFF1B242D), Color(0xFF2B3A4A)],
    'blue': [Color(0xFF274C86), Color(0xFF3F6FB5)],
    'teal': [Color(0xFF14524F), Color(0xFF23807A)],
  };
}
