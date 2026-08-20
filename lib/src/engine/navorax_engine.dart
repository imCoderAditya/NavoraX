import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';

/// Typedef alias for backward compatibility.
typedef NavigationEngine = NavoraXEngine;

/// Engine responsible for path clipping, vector rendering, custom painting,
/// neumorphic highlights, and glassmorphic filters across NavoraX shapes.
class NavoraXEngine {
  /// Generates a clip path for the specified [shape] and dimensions.
  static CustomClipper<Path> getClipper(NavoraXShape shape, {double notchRadius = 28.0}) {
    switch (shape) {
      case NavoraXShape.notched:
        return NotchedNavClipper(notchRadius: notchRadius);
      case NavoraXShape.curved:
        return CurvedNavClipper();
      case NavoraXShape.wave:
        return WaveNavClipper();
      case NavoraXShape.asymmetric:
        return AsymmetricNavClipper();
      case NavoraXShape.capsule:
        return CapsuleNavClipper();
      default:
        return RectNavClipper();
    }
  }

  /// Calculates background decoration based on [backgroundStyle], [backgroundColor],
  /// [gradient], [borderRadius], [elevation], and [shadowColor].
  static BoxDecoration buildDecoration({
    required NavoraXBackgroundStyle backgroundStyle,
    Color? backgroundColor,
    Gradient? gradient,
    BorderRadius borderRadius = BorderRadius.zero,
    double elevation = 0,
    Color? shadowColor,
    Border? border,
    required bool isDark,
  }) {
    final baseColor = backgroundColor ??
        (isDark ? const Color(0xFF1E1E2C) : Colors.white);

    switch (backgroundStyle) {
      case NavoraXBackgroundStyle.glass:
      case NavoraXBackgroundStyle.glassMorph:
        return BoxDecoration(
          color: baseColor.withValues(alpha: isDark ? 0.35 : 0.65),
          borderRadius: borderRadius,
          border: border ??
              Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
                width: 1.5,
              ),
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: (shadowColor ?? Colors.black).withValues(alpha: 0.15),
                    blurRadius: elevation * 2,
                    spreadRadius: 1,
                    offset: Offset(0, elevation / 2),
                  ),
                ]
              : null,
        );

      case NavoraXBackgroundStyle.neumorphicFlat:
      case NavoraXBackgroundStyle.neumorphicConvex:
      case NavoraXBackgroundStyle.neumorphicConcave:
        final lightShadow = isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.85);
        final darkShadow = isDark
            ? Colors.black.withValues(alpha: 0.65)
            : const Color(0xFFA3B1C6).withValues(alpha: 0.5);

        return BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius,
          gradient: backgroundStyle == NavoraXBackgroundStyle.neumorphicConvex
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    baseColor.withValues(alpha: 0.9),
                    baseColor.withValues(alpha: 1.0),
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: lightShadow,
              offset: const Offset(-4, -4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: darkShadow,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        );

      case NavoraXBackgroundStyle.gradient:
        return BoxDecoration(
          gradient: gradient ??
              LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2C3E50), const Color(0xFF000000)]
                    : [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
              ),
          borderRadius: borderRadius,
          border: border,
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: (shadowColor ?? Colors.black).withValues(alpha: 0.2),
                    blurRadius: elevation * 2,
                    offset: Offset(0, elevation / 2),
                  ),
                ]
              : null,
        );

      case NavoraXBackgroundStyle.transparent:
        return const BoxDecoration(color: Colors.transparent);

      case NavoraXBackgroundStyle.solid:
        return BoxDecoration(
          color: baseColor,
          gradient: gradient,
          borderRadius: borderRadius,
          border: border,
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: (shadowColor ?? Colors.black).withValues(alpha: 0.12),
                    blurRadius: elevation * 2,
                    offset: Offset(0, elevation / 2),
                  ),
                ]
              : null,
        );
    }
  }
}

/// Simple rectangular clipper fallback.
class RectNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper for center FAB notched nav bars.
class NotchedNavClipper extends CustomClipper<Path> {
  final double notchRadius;

  NotchedNavClipper({this.notchRadius = 28.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = size.width / 2;
    final r = notchRadius;
    const margin = 8.0;

    path.moveTo(0, 0);
    path.lineTo(center - r - margin, 0);
    path.quadraticBezierTo(
      center - r,
      0,
      center - r + 4,
      r * 0.4,
    );
    path.arcToPoint(
      Offset(center + r - 4, r * 0.4),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.quadraticBezierTo(
      center + r,
      0,
      center + r + margin,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(NotchedNavClipper oldClipper) =>
      oldClipper.notchRadius != notchRadius;
}

/// Clipper for smooth concave curved top.
class CurvedNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 16);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 16);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper for sine wave shape.
class WaveNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 10);
    final width = size.width;

    path.cubicTo(
      width * 0.25,
      0,
      width * 0.25,
      20,
      width * 0.5,
      10,
    );
    path.cubicTo(
      width * 0.75,
      0,
      width * 0.75,
      20,
      width,
      10,
    );

    path.lineTo(width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper for modern capsule shape.
class CapsuleNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.height / 2;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper for asymmetric futuristic shapes.
class AsymmetricNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 12);
    path.lineTo(size.width - 24, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Custom painter for sliding item selection indicators.
class ActiveIndicatorPainter extends CustomPainter {
  final double position;
  final int count;
  final NavoraXIndicator indicator;
  final Color color;

  ActiveIndicatorPainter({
    required this.position,
    required this.count,
    required this.indicator,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (indicator == NavoraXIndicator.none || count == 0) return;

    final itemWidth = size.width / count;
    final centerX = itemWidth * position + itemWidth / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Center point of active icon (positioned in upper portion of nav bar)
    final iconCenterY = size.height * 0.36;

    switch (indicator) {
      case NavoraXIndicator.lineTop:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(centerX - 16, 0, 32, 4),
            const Radius.circular(2),
          ),
          paint,
        );
        break;

      case NavoraXIndicator.lineBottom:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(centerX - 16, size.height - 4, 32, 4),
            const Radius.circular(2),
          ),
          paint,
        );
        break;

      case NavoraXIndicator.dot:
        canvas.drawCircle(Offset(centerX, size.height - 5), 3.5, paint);
        break;

      case NavoraXIndicator.glow:
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(Offset(centerX, iconCenterY), itemWidth * 0.28, glowPaint);
        break;

      case NavoraXIndicator.pill:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              centerX - (itemWidth * 0.38),
              size.height * 0.12,
              itemWidth * 0.76,
              size.height * 0.76,
            ),
            const Radius.circular(20),
          ),
          paint,
        );
        break;

      case NavoraXIndicator.ring:
        final ringPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        // Draw ring around icon center so it never overlaps the label text below
        canvas.drawCircle(Offset(centerX, iconCenterY), 18, ringPaint);
        break;

      case NavoraXIndicator.liquidBubble:
        final path = Path();
        path.moveTo(centerX - 24, size.height);
        path.quadraticBezierTo(
          centerX,
          size.height * 0.2,
          centerX + 24,
          size.height,
        );
        canvas.drawPath(path, paint);
        break;

      default:
        canvas.drawCircle(Offset(centerX, size.height - 5), 3, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(ActiveIndicatorPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.indicator != indicator ||
        oldDelegate.color != color;
  }
}
