import 'dart:ui';
import 'package:flutter/material.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  Liquid Glass Theme — Apple 2025 Inspired
//  Supports light & dark modes with system auto-switch
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Color tokens that adapt to brightness.
class GlassTokens {
  final Brightness brightness;

  const GlassTokens._(this.brightness);
  static const light = GlassTokens._(Brightness.light);
  static const dark = GlassTokens._(Brightness.dark);

  /// Get tokens for the current theme brightness.
  static GlassTokens of(BuildContext context) {
    final b = Theme.of(context).brightness;
    return b == Brightness.dark ? GlassTokens.dark : GlassTokens.light;
  }

  bool get isDark => brightness == Brightness.dark;

  // ── Backgrounds ──
  Color get scaffoldBg =>
      isDark ? const Color(0xFF0A0A14) : const Color(0xFFF2F2F7);

  Color get panelFill =>
      isDark
          ? const Color(0xFF1A1A2E).withValues(alpha: 0.65)
          : Colors.white.withValues(alpha: 0.72);

  Color get panelFillAlt =>
      isDark
          ? const Color(0xFF14142A).withValues(alpha: 0.55)
          : const Color(0xFFF8F8FC).withValues(alpha: 0.65);

  Color get cardFill =>
      isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.55);

  Color get inputFill =>
      isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.03);

  // ── Borders ──
  Color get glassBorder =>
      isDark
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.white.withValues(alpha: 0.6);

  Color get glassBorderOuter =>
      isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.06);

  Color get inputBorder =>
      isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.08);

  Color get inputFocusBorder =>
      isDark
          ? const Color(0xFF7C8CF8).withValues(alpha: 0.6)
          : const Color(0xFF5856D6).withValues(alpha: 0.5);

  // ── Text ──
  Color get textPrimary =>
      isDark ? const Color(0xFFE8E8F0) : const Color(0xFF1C1C1E);

  Color get textSecondary =>
      isDark ? const Color(0xFF8888A4) : const Color(0xFF8E8E93);

  Color get textTertiary =>
      isDark ? const Color(0xFF5A5A72) : const Color(0xFFC7C7CC);

  // ── Accent ──
  Color get primary =>
      isDark ? const Color(0xFF7C8CF8) : const Color(0xFF5856D6);

  Color get primarySoft =>
      isDark
          ? const Color(0xFF7C8CF8).withValues(alpha: 0.15)
          : const Color(0xFF5856D6).withValues(alpha: 0.10);

  // ── Gradients for buttons ──
  List<Color> get primaryGradient =>
      isDark
          ? [const Color(0xFF6366F1), const Color(0xFF818CF8)]
          : [const Color(0xFF5856D6), const Color(0xFF7B7BF7)];

  // ── Log colors ──
  Color get logBg =>
      isDark
          ? Colors.black.withValues(alpha: 0.35)
          : Colors.black.withValues(alpha: 0.04);

  Color get logSuccess =>
      isDark ? const Color(0xFF50FA7B) : const Color(0xFF34C759);
  Color get logError =>
      isDark ? const Color(0xFFFF6E6E) : const Color(0xFFFF3B30);
  Color get logWarning =>
      isDark ? const Color(0xFFFFB86C) : const Color(0xFFFF9500);
  Color get logInfo =>
      isDark ? const Color(0xFF8BE9FD) : const Color(0xFF007AFF);
  Color get logDefault =>
      isDark ? const Color(0xFFA0A0C0) : const Color(0xFF636366);

  // ── Blur ──
  double get blurSigma => isDark ? 40.0 : 30.0;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  GlassPanel — Reusable frosted glass container
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? fillOverride;
  final Color? borderOverride;
  final double? blurOverride;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.fillOverride,
    this.borderOverride,
    this.blurOverride,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = GlassTokens.of(context);
    final radius = borderRadius ?? BorderRadius.circular(16);
    final sigma = blurOverride ?? tokens.blurSigma;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fillOverride ?? tokens.panelFill,
            borderRadius: radius,
            border: Border.all(
              color: borderOverride ?? tokens.glassBorder,
              width: 0.5,
            ),
            // Subtle top-light shimmer
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: tokens.isDark ? 0.04 : 0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  Theme Data builder
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class LiquidGlassTheme {
  static ThemeData get lightTheme => _buildTheme(GlassTokens.light);
  static ThemeData get darkTheme => _buildTheme(GlassTokens.dark);

  static ThemeData _buildTheme(GlassTokens t) {
    final colorScheme = ColorScheme(
      brightness: t.brightness,
      primary: t.primary,
      onPrimary: Colors.white,
      secondary: t.primary.withValues(alpha: 0.8),
      onSecondary: Colors.white,
      error: t.logError,
      onError: Colors.white,
      surface: t.scaffoldBg,
      onSurface: t.textPrimary,
      outline: t.inputBorder,
      surfaceContainerHighest:
          t.isDark ? const Color(0xFF232340) : const Color(0xFFE5E5EA),
    );

    return ThemeData(
      brightness: t.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: t.scaffoldBg,
      useMaterial3: true,
      fontFamily: '.AppleSystemUIFont',

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: t.textSecondary,
          letterSpacing: 2.0,
        ),
      ),

      // ── Input Fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.inputBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.inputBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: t.inputFocusBorder, width: 1.2),
        ),
        labelStyle: TextStyle(
          color: t.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(color: t.textTertiary),
        isDense: true,
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: t.cardFill,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: t.glassBorderOuter, width: 0.5),
        ),
      ),

      // ── Filled Button ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: t.textPrimary,
          side: BorderSide(color: t.inputBorder, width: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(color: t.inputBorder, thickness: 0.5),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor:
            t.isDark ? const Color(0xFF1E1E36) : const Color(0xFFF5F5FA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),

      // ── Date Picker ──
      datePickerTheme: DatePickerThemeData(
        backgroundColor:
            t.isDark ? const Color(0xFF1E1E36) : const Color(0xFFF5F5FA),
        headerBackgroundColor: t.primarySoft,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
