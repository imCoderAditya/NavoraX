import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';

/// Typedef alias for backward compatibility.
typedef AdaptiveEngine = NavoraXAdaptiveEngine;

/// Engine responsible for evaluating context, screen dimensions, theme modes,
/// accessibility preferences, and OLED dark settings to produce adapted [NavoraXConfig]s.
class NavoraXAdaptiveEngine {
  /// Adapts a base [NavoraXConfig] based on [BuildContext] environment.
  static NavoraXConfig adapt(
    NavoraXConfig baseConfig,
    BuildContext context, {
    bool enableAdaptive = true,
  }) {
    if (!enableAdaptive) return baseConfig;

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOledDark = isDark && (theme.scaffoldBackgroundColor == Colors.black);
    final isReducedMotion = mediaQuery.disableAnimations;
    final screenWidth = mediaQuery.size.width;

    NavoraXShape adaptedShape = baseConfig.shape;
    NavoraXBackgroundStyle adaptedBgStyle = baseConfig.backgroundStyle;
    Color? adaptedBgColor = baseConfig.backgroundColor;
    NavoraXAnimation adaptedAnimation = baseConfig.animation;
    double adaptedHeight = baseConfig.height;
    EdgeInsets adaptedMargin = baseConfig.margin;

    // 1. OLED Dark Mode adaptation
    if (isOledDark) {
      adaptedBgStyle = NavoraXBackgroundStyle.solid;
      adaptedBgColor = Colors.black;
      if (adaptedShape == NavoraXShape.flat) {
        adaptedShape = NavoraXShape.floating;
        adaptedMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      }
    } else if (isDark && baseConfig.backgroundStyle == NavoraXBackgroundStyle.solid) {
      adaptedBgColor = baseConfig.backgroundColor ?? const Color(0xFF1E1E2C);
    }

    // 2. Responsive tablet & screen size adaptation
    if (screenWidth > 800) {
      // Large screen / tablet -> Floating pill mode
      if (adaptedShape == NavoraXShape.flat) {
        adaptedShape = NavoraXShape.pill;
        adaptedMargin = EdgeInsets.symmetric(
          horizontal: screenWidth * 0.2,
          vertical: 12,
        );
      }
    } else if (screenWidth < 360) {
      // Small screen -> Compact height
      adaptedHeight = mathMax(52.0, baseConfig.height - 8);
    }

    // 3. Accessibility & reduced motion adaptation
    if (isReducedMotion) {
      adaptedAnimation = NavoraXAnimation.none;
    }

    return baseConfig.copyWith(
      shape: adaptedShape,
      backgroundStyle: adaptedBgStyle,
      backgroundColor: adaptedBgColor,
      animation: adaptedAnimation,
      height: adaptedHeight,
      margin: adaptedMargin,
    );
  }

  static double mathMax(double a, double b) => a > b ? a : b;
}
