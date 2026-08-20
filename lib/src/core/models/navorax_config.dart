import 'package:flutter/material.dart';
import '../navorax_enums.dart';

/// Typedef alias for backward compatibility.
typedef NavigationConfig = NavoraXConfig;

/// Complete design configuration object specifying visual properties, layout,
/// animation, and rendering engine behavior for a NavoraX navigation bar.
@immutable
class NavoraXConfig {
  final String id;
  final String name;
  final NavoraXCategory category;
  final NavoraXShape shape;
  final NavoraXIndicator indicator;
  final NavoraXAnimation animation;
  final NavoraXIconStyle iconStyle;
  final NavoraXLabelStyle labelStyle;
  final NavoraXBackgroundStyle backgroundStyle;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final Gradient? gradient;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double height;
  final double elevation;
  final double blurAmount;
  final Color? shadowColor;
  final Border? border;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool hapticFeedback;
  final double iconSize;
  final double activeIconSize;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  const NavoraXConfig({
    required this.id,
    required this.name,
    this.category = NavoraXCategory.modern,
    this.shape = NavoraXShape.flat,
    this.indicator = NavoraXIndicator.lineTop,
    this.animation = NavoraXAnimation.fade,
    this.iconStyle = NavoraXIconStyle.standard,
    this.labelStyle = NavoraXLabelStyle.alwaysShow,
    this.backgroundStyle = NavoraXBackgroundStyle.solid,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.gradient,
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.margin = EdgeInsets.zero,
    this.height = 64.0,
    this.elevation = 4.0,
    this.blurAmount = 10.0,
    this.shadowColor,
    this.border,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.hapticFeedback = true,
    this.iconSize = 24.0,
    this.activeIconSize = 26.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  /// Copy with modifications.
  NavoraXConfig copyWith({
    String? id,
    String? name,
    NavoraXCategory? category,
    NavoraXShape? shape,
    NavoraXIndicator? indicator,
    NavoraXAnimation? animation,
    NavoraXIconStyle? iconStyle,
    NavoraXLabelStyle? labelStyle,
    NavoraXBackgroundStyle? backgroundStyle,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? indicatorColor,
    Gradient? gradient,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? height,
    double? elevation,
    double? blurAmount,
    Color? shadowColor,
    Border? border,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? hapticFeedback,
    double? iconSize,
    double? activeIconSize,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
  }) {
    return NavoraXConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      shape: shape ?? this.shape,
      indicator: indicator ?? this.indicator,
      animation: animation ?? this.animation,
      iconStyle: iconStyle ?? this.iconStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      gradient: gradient ?? this.gradient,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      height: height ?? this.height,
      elevation: elevation ?? this.elevation,
      blurAmount: blurAmount ?? this.blurAmount,
      shadowColor: shadowColor ?? this.shadowColor,
      border: border ?? this.border,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      iconSize: iconSize ?? this.iconSize,
      activeIconSize: activeIconSize ?? this.activeIconSize,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
    );
  }

  /// Serialize to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'shape': shape.name,
      'indicator': indicator.name,
      'animation': animation.name,
      'iconStyle': iconStyle.name,
      'labelStyle': labelStyle.name,
      'backgroundStyle': backgroundStyle.name,
      'backgroundColor': backgroundColor?.toARGB32(),
      'activeColor': activeColor?.toARGB32(),
      'inactiveColor': inactiveColor?.toARGB32(),
      'indicatorColor': indicatorColor?.toARGB32(),
      'height': height,
      'elevation': elevation,
      'blurAmount': blurAmount,
      'shadowColor': shadowColor?.toARGB32(),
      'hapticFeedback': hapticFeedback,
      'iconSize': iconSize,
      'activeIconSize': activeIconSize,
    };
  }

  /// Deserialize from JSON map.
  factory NavoraXConfig.fromJson(Map<String, dynamic> json) {
    return NavoraXConfig(
      id: json['id'] as String? ?? 'custom_config',
      name: json['name'] as String? ?? 'Custom Navigation',
      category: NavoraXCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NavoraXCategory.modern,
      ),
      shape: NavoraXShape.values.firstWhere(
        (e) => e.name == json['shape'],
        orElse: () => NavoraXShape.flat,
      ),
      indicator: NavoraXIndicator.values.firstWhere(
        (e) => e.name == json['indicator'],
        orElse: () => NavoraXIndicator.lineTop,
      ),
      animation: NavoraXAnimation.values.firstWhere(
        (e) => e.name == json['animation'],
        orElse: () => NavoraXAnimation.fade,
      ),
      iconStyle: NavoraXIconStyle.values.firstWhere(
        (e) => e.name == json['iconStyle'],
        orElse: () => NavoraXIconStyle.standard,
      ),
      labelStyle: NavoraXLabelStyle.values.firstWhere(
        (e) => e.name == json['labelStyle'],
        orElse: () => NavoraXLabelStyle.alwaysShow,
      ),
      backgroundStyle: NavoraXBackgroundStyle.values.firstWhere(
        (e) => e.name == json['backgroundStyle'],
        orElse: () => NavoraXBackgroundStyle.solid,
      ),
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
      activeColor: json['activeColor'] != null
          ? Color(json['activeColor'] as int)
          : null,
      inactiveColor: json['inactiveColor'] != null
          ? Color(json['inactiveColor'] as int)
          : null,
      indicatorColor: json['indicatorColor'] != null
          ? Color(json['indicatorColor'] as int)
          : null,
      height: (json['height'] as num?)?.toDouble() ?? 64.0,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 4.0,
      blurAmount: (json['blurAmount'] as num?)?.toDouble() ?? 10.0,
      shadowColor: json['shadowColor'] != null
          ? Color(json['shadowColor'] as int)
          : null,
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      iconSize: (json['iconSize'] as num?)?.toDouble() ?? 24.0,
      activeIconSize: (json['activeIconSize'] as num?)?.toDouble() ?? 26.0,
    );
  }
}
