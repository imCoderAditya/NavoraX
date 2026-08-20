import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';

/// Typedef alias for backward compatibility.
typedef AnimationEngine = NavoraXAnimationEngine;

/// NavoraX Animation Engine handling physics curves, item transitions, morphing curves,
/// and indicator interpolations.
class NavoraXAnimationEngine {
  /// Map [NavoraXAnimation] to Flutter animation curve.
  static Curve getCurve(NavoraXAnimation animation) {
    switch (animation) {
      case NavoraXAnimation.elastic:
        return Curves.elasticOut;
      case NavoraXAnimation.bounce:
        return Curves.bounceOut;
      case NavoraXAnimation.spring:
        return const SpringCurve();
      case NavoraXAnimation.liquid:
        return Curves.easeInOutCubicEmphasized;
      case NavoraXAnimation.magnetic:
        return Curves.fastOutSlowIn;
      case NavoraXAnimation.morph:
        return Curves.fastLinearToSlowEaseIn;
      case NavoraXAnimation.scale:
        return Curves.easeOutBack;
      default:
        return Curves.easeInOut;
    }
  }

  /// Calculates animation duration based on animation style and performance mode.
  static Duration getDuration(
    NavoraXAnimation animation, {
    Duration? customDuration,
    bool reducedMotion = false,
  }) {
    if (reducedMotion) return Duration.zero;
    if (customDuration != null) return customDuration;

    switch (animation) {
      case NavoraXAnimation.elastic:
      case NavoraXAnimation.bounce:
        return const Duration(milliseconds: 500);
      case NavoraXAnimation.liquid:
      case NavoraXAnimation.morph:
        return const Duration(milliseconds: 400);
      case NavoraXAnimation.none:
        return Duration.zero;
      default:
        return const Duration(milliseconds: 300);
    }
  }

  /// Builds transition widget for morphing item changes or icon interactions.
  static Widget buildItemTransition({
    required Widget child,
    required Animation<double> animation,
    required NavoraXAnimation type,
  }) {
    switch (type) {
      case NavoraXAnimation.fade:
        return FadeTransition(opacity: animation, child: child);

      case NavoraXAnimation.scale:
        return ScaleTransition(scale: animation, child: child);

      case NavoraXAnimation.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case NavoraXAnimation.rotate:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );

      case NavoraXAnimation.bounce:
      case NavoraXAnimation.elastic:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            ),
          ),
          child: child,
        );

      case NavoraXAnimation.none:
      default:
        return child;
    }
  }
}

/// Custom Spring Curve simulation in NavoraX.
class SpringCurve extends Curve {
  final double tension;
  final double friction;

  const SpringCurve({this.tension = 100.0, this.friction = 10.0});

  @override
  double transformInternal(double t) {
    return 1 - (t * 10 * (1 - t) * (1 - t));
  }
}
