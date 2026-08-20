import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_badge.dart';

/// Typedef alias for backward compatibility.
typedef NavBadgeWidget = NavoraXBadgeWidget;

/// Widget rendering badges over NavoraX navigation items.
class NavoraXBadgeWidget extends StatefulWidget {
  final NavoraXBadge badge;
  final Widget child;

  const NavoraXBadgeWidget({
    super.key,
    required this.badge,
    required this.child,
  });

  @override
  State<NavoraXBadgeWidget> createState() => _NavoraXBadgeWidgetState();
}

class _NavoraXBadgeWidgetState extends State<NavoraXBadgeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.badge.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(NavoraXBadgeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.badge.animate != oldWidget.badge.animate) {
      if (widget.badge.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.badge.type == NavoraXBadgeType.custom &&
        widget.badge.customWidget != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          Positioned(
            right: -6 + widget.badge.offset.dx,
            top: -4 + widget.badge.offset.dy,
            child: widget.badge.customWidget!,
          ),
        ],
      );
    }

    final bg = widget.badge.backgroundColor ?? const Color(0xFFEF4444);
    final textCol = widget.badge.textColor ?? Colors.white;

    Widget badgeContent;
    switch (widget.badge.type) {
      case NavoraXBadgeType.dot:
        badgeContent = Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
        );
        break;

      case NavoraXBadgeType.count:
        final countText = (widget.badge.count ?? 0) > 99
            ? '99+'
            : (widget.badge.count ?? 0).toString();
        badgeContent = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            countText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textCol,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        break;

      case NavoraXBadgeType.text:
        badgeContent = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.badge.text ?? '',
            style: TextStyle(
              color: textCol,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        break;

      default:
        badgeContent = const SizedBox.shrink();
    }

    if (widget.badge.animate) {
      badgeContent = ScaleTransition(
        scale: _pulseAnimation,
        child: badgeContent,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          right: -8 + widget.badge.offset.dx,
          top: -4 + widget.badge.offset.dy,
          child: badgeContent,
        ),
      ],
    );
  }
}
