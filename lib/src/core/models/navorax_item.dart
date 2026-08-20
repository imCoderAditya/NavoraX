import 'package:flutter/material.dart';
import 'navorax_badge.dart';

/// Typedef aliases for backward compatibility.
typedef BottomNavItem = NavoraXItem;
typedef NavoraXNavItem = NavoraXItem;

/// Data model representing a single navigation item / tab in NavoraX.
@immutable
class NavoraXItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;
  final NavoraXBadge? badge;
  final String? semanticLabel;
  final bool enabled;
  final Widget? customWidget;
  final Color? activeColor;
  final Color? inactiveColor;

  const NavoraXItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
    this.badge,
    this.semanticLabel,
    this.enabled = true,
    this.customWidget,
    this.activeColor,
    this.inactiveColor,
  });

  /// Helper to copy nav item with optional parameter overrides.
  NavoraXItem copyWith({
    IconData? icon,
    IconData? activeIcon,
    String? label,
    String? tooltip,
    NavoraXBadge? badge,
    String? semanticLabel,
    bool? enabled,
    Widget? customWidget,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    return NavoraXItem(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      tooltip: tooltip ?? this.tooltip,
      badge: badge ?? this.badge,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      enabled: enabled ?? this.enabled,
      customWidget: customWidget ?? this.customWidget,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
    );
  }
}
