import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF087A55);
  static const Color primaryLight = Color(0xFF0EA372);
  static const Color primaryDark = Color(0xFF065E42);
  static const Color primarySurface = Color(0xFFE8F6F0);
  static const Color primaryHover = Color(0xFF076C4B);

  // 3D Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0FA875), Color(0xFF066749)],
  );

  static const LinearGradient primaryGradientElevated = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF13BE86), Color(0xFF076E4E)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFFBFDFC)],
  );

  static const LinearGradient cardGradientSubtle = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF6FAF8)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF162A23), Color(0xFF0E1A16)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A6347), Color(0xFF043828)],
  );

  static const LinearGradient accentGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x330FA875), Color(0x050FA875)],
  );

  // Backgrounds
  static const Color background = Color(0xFFF4F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFECF2EF);
  static const Color sidebarBackground = Color(0xFF0D1B16);
  static const Color cardSurface3D = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF15221E);
  static const Color textSecondary = Color(0xFF45544F);
  static const Color textMuted = Color(0xFF74827D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border & 3D Specular Highlights
  static const Color border = Color(0xFFE2E8E5);
  static const Color borderDark = Color(0xFFCBD6D1);
  static const Color borderSubtle = Color(0xFFEFF3F1);
  static const Color specularHighlight = Color(0x99FFFFFF);
  static const Color bevelBottom = Color(0x1A000000);

  // Status
  static const Color success = Color(0xFF138A5E);
  static const Color successSurface = Color(0xFFE8F7F0);
  static const Color warning = Color(0xFFDF9B21);
  static const Color warningSurface = Color(0xFFFEF7E8);
  static const Color danger = Color(0xFFDB4848);
  static const Color dangerSurface = Color(0xFFFDEEEE);
  static const Color info = Color(0xFF2879F4);
  static const Color infoSurface = Color(0xFFEBF3FE);

  // Sidebar
  static const Color sidebarText = Color(0xFFB5C4BE);
  static const Color sidebarActiveText = Color(0xFFFFFFFF);
  static const Color sidebarActiveBg = Color(0xFF173026);
  static const Color sidebarHoverBg = Color(0xFF13261F);
  static const Color sidebarGroupLabel = Color(0xFF5E756D);

  // Misc
  static const Color divider = Color(0xFFEBF0ED);
  static const Color cardShadow = Color(0x0A18231F);
  static const Color overlay = Color(0x8018231F);

  // 3D Shadow Presets
  static List<BoxShadow> get shadow3DSubtle => [
    BoxShadow(
      color: const Color(0xFF0F1F1A).withValues(alpha: 0.03),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF087A55).withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get shadow3DCard => [
    BoxShadow(
      color: const Color(0xFF0D1B16).withValues(alpha: 0.05),
      offset: const Offset(0, 8),
      blurRadius: 20,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: const Color(0xFF087A55).withValues(alpha: 0.03),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get shadow3DElevated => [
    BoxShadow(
      color: const Color(0xFF0D1B16).withValues(alpha: 0.08),
      offset: const Offset(0, 14),
      blurRadius: 28,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: const Color(0xFF087A55).withValues(alpha: 0.05),
      offset: const Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get shadow3DButton => [
    BoxShadow(
      color: const Color(0xFF087A55).withValues(alpha: 0.32),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: const Color(0xFF087A55).withValues(alpha: 0.16),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> shadowGlow(Color color, {double opacity = 0.28, double blur = 14}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      offset: const Offset(0, 4),
      blurRadius: blur,
      spreadRadius: -2,
    ),
  ];

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF087A55),
    Color(0xFF2E7CF6),
    Color(0xFFD99A28),
    Color(0xFFD94F4F),
    Color(0xFF7C5CFC),
    Color(0xFF0BBFA8),
  ];
}

