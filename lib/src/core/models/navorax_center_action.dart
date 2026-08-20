import 'package:flutter/material.dart';

/// Typedef alias for backward compatibility.
typedef NavCenterAction = NavoraXCenterAction;

/// Center action button / FAB configuration for notched & dock style navigation in NavoraX.
@immutable
class NavoraXCenterAction {
  final IconData? icon;
  final IconData? activeIcon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double elevation;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? customWidget;
  final double size;
  final BoxShape shape;
  final bool isNotched;

  const NavoraXCenterAction({
    this.icon = Icons.add,
    this.activeIcon,
    this.onTap,
    this.tooltip,
    this.elevation = 4.0,
    this.gradient,
    this.backgroundColor,
    this.iconColor,
    this.customWidget,
    this.size = 56.0,
    this.shape = BoxShape.circle,
    this.isNotched = true,
  });
}
