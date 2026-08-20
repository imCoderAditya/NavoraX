import 'package:flutter/material.dart';

/// Typedef aliases for backward compatibility.
typedef SmartBottomNavThemeData = NavoraXThemeData;
typedef SmartBottomNavTheme = NavoraXTheme;

/// Theme data for NavoraX widgets.
@immutable
class NavoraXThemeData {
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BorderRadius? borderRadius;
  final double? height;
  final double? elevation;

  const NavoraXThemeData({
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.borderRadius,
    this.height,
    this.elevation,
  });

  /// Copy with modifications.
  NavoraXThemeData copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? indicatorColor,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
    BorderRadius? borderRadius,
    double? height,
    double? elevation,
  }) {
    return NavoraXThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      elevation: elevation ?? this.elevation,
    );
  }
}

/// InheritedWidget providing [NavoraXThemeData] to descendants.
class NavoraXTheme extends InheritedWidget {
  final NavoraXThemeData data;

  const NavoraXTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static NavoraXThemeData? of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<NavoraXTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(NavoraXTheme oldWidget) {
    return data != oldWidget.data;
  }
}
