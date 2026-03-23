import 'package:flutter/material.dart';

/// CaliDay brand design tokens and ThemeData factory.
///
/// Usage in MaterialApp:
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
abstract final class AppTheme {
  // ── Brand colours ──────────────────────────────────────────────────────────

  /// Main brand blue — buttons, accents, Goro's headband environment.
  static const Color brandBlue = Color(0xFF4DA6FF);

  /// Darker blue for gradients and active states.
  static const Color brandBlueDark = Color(0xFF2B7DE9);

  /// Deep blue for gradient bottom stop on hero zone.
  static const Color brandBlueDeep = Color(0xFF1A5FA8);

  /// Energy orange — streaks, fire, SP rewards.
  static const Color energy = Color(0xFFFF9500);

  /// Muted orange container for streak cells (light mode).
  static const Color energyContainer = Color(0xFFFFF0D9);

  /// Muted orange container for streak cells (dark mode).
  static const Color energyContainerDark = Color(0xFF3D2800);

  /// Success green — progress, completion, unlock.
  static const Color success = Color(0xFF34C759);

  // ── Shadows ────────────────────────────────────────────────────────────────

  static List<BoxShadow> get cardShadowLight => [
        BoxShadow(
          color: const Color(0xFF000000).withAlpha(18),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: const Color(0xFF000000).withAlpha(60),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // ── Gradient decorations ───────────────────────────────────────────────────

  /// Hero gradient used on the Home screen behind Goro.
  static const Gradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandBlue, brandBlueDeep],
  );

  /// Rank card gradient — same blue family, slightly darker.
  static const Gradient rankGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandBlue, brandBlueDark],
  );

  // ── ThemeData ──────────────────────────────────────────────────────────────

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: brandBlue,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFDCEEFF),
          onPrimaryContainer: brandBlueDeep,
          secondary: brandBlueDark,
          tertiary: success,
          error: const Color(0xFFE53935),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: brandBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandBlue,
          brightness: Brightness.dark,
        ).copyWith(
          primary: brandBlue,
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF1A3A5C),
          onPrimaryContainer: const Color(0xFFB8D9FF),
          secondary: const Color(0xFF7FC3FF),
          tertiary: success,
          error: const Color(0xFFEF5350),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: brandBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
}