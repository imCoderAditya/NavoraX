import 'package:flutter/material.dart';
import '../navorax_enums.dart';

/// Typedef alias for backward compatibility.
typedef NavBadge = NavoraXBadge;

/// Represents a badge overlaid on a NavoraX navigation item.
@immutable
class NavoraXBadge {
  final NavoraXBadgeType type;
  final int? count;
  final String? text;
  final Widget? customWidget;
  final Color? backgroundColor;
  final Color? textColor;
  final bool animate;
  final Offset offset;

  const NavoraXBadge({
    required this.type,
    this.count,
    this.text,
    this.customWidget,
    this.backgroundColor,
    this.textColor,
    this.animate = false,
    this.offset = const Offset(0, 0),
  });

  /// Factory for a numeric count badge.
  factory NavoraXBadge.count(
    int count, {
    Color? backgroundColor,
    Color? textColor,
    bool animate = true,
  }) {
    return NavoraXBadge(
      type: NavoraXBadgeType.count,
      count: count,
      backgroundColor: backgroundColor,
      textColor: textColor,
      animate: animate,
    );
  }

  /// Factory for a small status dot badge.
  factory NavoraXBadge.dot({
    Color? backgroundColor,
    bool animate = false,
  }) {
    return NavoraXBadge(
      type: NavoraXBadgeType.dot,
      backgroundColor: backgroundColor,
      animate: animate,
    );
  }

  /// Factory for a custom text string badge (e.g. 'NEW', 'HOT').
  factory NavoraXBadge.text(
    String text, {
    Color? backgroundColor,
    Color? textColor,
    bool animate = false,
  }) {
    return NavoraXBadge(
      type: NavoraXBadgeType.text,
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      animate: animate,
    );
  }

  /// Factory for a custom widget badge.
  factory NavoraXBadge.custom(
    Widget widget, {
    Offset offset = const Offset(0, 0),
  }) {
    return NavoraXBadge(
      type: NavoraXBadgeType.custom,
      customWidget: widget,
      offset: offset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'count': count,
      'text': text,
      'backgroundColor': backgroundColor?.toARGB32(),
      'textColor': textColor?.toARGB32(),
      'animate': animate,
    };
  }

  factory NavoraXBadge.fromJson(Map<String, dynamic> json) {
    return NavoraXBadge(
      type: NavoraXBadgeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NavoraXBadgeType.dot,
      ),
      count: json['count'] as int?,
      text: json['text'] as String?,
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
      textColor: json['textColor'] != null
          ? Color(json['textColor'] as int)
          : null,
      animate: json['animate'] as bool? ?? false,
    );
  }
}
