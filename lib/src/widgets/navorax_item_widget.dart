import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_item.dart';
import '../core/models/navorax_config.dart';
import 'navorax_badge_widget.dart';

/// Typedef alias for backward compatibility.
typedef NavItemWidget = NavoraXItemWidget;

/// Widget rendering a single item/tab within [NavoraX].
class NavoraXItemWidget extends StatelessWidget {
  final NavoraXItem item;
  final bool isSelected;
  final NavoraXConfig config;
  final VoidCallback onTap;
  final Animation<double> animation;

  const NavoraXItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.config,
    required this.onTap,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (item.customWidget != null) {
      return GestureDetector(
        onTap: item.enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: item.customWidget!,
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    Color activeCol = item.activeColor ?? config.activeColor ?? primaryColor;
    Color inactiveCol = item.inactiveColor ??
        config.inactiveColor ??
        (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    // Dynamic contrast adaptation for dark mode / dark backgrounds
    if (isDark && activeCol.computeLuminance() < 0.25) {
      activeCol = const Color(0xFF38BDF8);
    }

    final color = isSelected ? activeCol : inactiveCol;
    final iconData = (isSelected && item.activeIcon != null)
        ? item.activeIcon!
        : item.icon;

    bool showLabel = true;
    switch (config.labelStyle) {
      case NavoraXLabelStyle.neverShow:
        showLabel = false;
        break;
      case NavoraXLabelStyle.selectedOnly:
        showLabel = isSelected;
        break;
      case NavoraXLabelStyle.alwaysShow:
      default:
        showLabel = true;
        break;
    }

    double scale = 1.0;
    if (isSelected && config.iconStyle == NavoraXIconStyle.animatedScale) {
      scale = 1.15;
    }

    Widget iconWidget = Icon(
      iconData,
      size: isSelected ? config.activeIconSize : config.iconSize,
      color: color,
    );

    if (config.iconStyle == NavoraXIconStyle.glowing && isSelected) {
      iconWidget = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: activeCol.withValues(alpha: 0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: iconWidget,
      );
    }

    if (scale != 1.0) {
      iconWidget = AnimatedScale(
        scale: scale,
        duration: config.animationDuration,
        curve: config.animationCurve,
        child: iconWidget,
      );
    }

    if (item.badge != null) {
      iconWidget = NavoraXBadgeWidget(
        badge: item.badge!,
        child: iconWidget,
      );
    }

    final defaultTextStyle = TextStyle(
      fontSize: 11,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      color: color,
    );

    Widget content = Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            if (showLabel && item.label.isNotEmpty) ...[
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: config.animationDuration,
                style: isSelected
                    ? (config.selectedLabelStyle ?? defaultTextStyle)
                    : (config.unselectedLabelStyle ?? defaultTextStyle),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    Widget result = Semantics(
      selected: isSelected,
      label: item.semanticLabel ?? item.label,
      enabled: item.enabled,
      button: true,
      child: InkWell(
        onTap: item.enabled ? onTap : null,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: content,
        ),
      ),
    );

    if (item.tooltip != null && item.tooltip!.isNotEmpty) {
      result = Tooltip(
        message: item.tooltip!,
        child: result,
      );
    }

    return Expanded(child: result);
  }
}
