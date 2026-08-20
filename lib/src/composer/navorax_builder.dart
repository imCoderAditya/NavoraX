import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';

/// Typedef aliases for backward compatibility and intuitive brand usage.
typedef SmartNavBuilder = NavoraXNavBuilder;
typedef NavoraXComposer = NavoraXNavBuilder;
typedef NavoraXBuilder = NavoraXNavBuilder;

/// Fluent builder for creating custom NavoraX navigation configurations (Navigation Composer).
class NavoraXNavBuilder {
  String _id = 'custom_builder_${DateTime.now().millisecondsSinceEpoch}';
  String _name = 'Custom Navigation';
  NavoraXCategory _category = NavoraXCategory.modern;
  NavoraXShape _shape = NavoraXShape.flat;
  NavoraXIndicator _indicator = NavoraXIndicator.lineTop;
  NavoraXAnimation _animation = NavoraXAnimation.fade;
  NavoraXIconStyle _iconStyle = NavoraXIconStyle.standard;
  NavoraXLabelStyle _labelStyle = NavoraXLabelStyle.alwaysShow;
  NavoraXBackgroundStyle _backgroundStyle = NavoraXBackgroundStyle.solid;
  Color? _backgroundColor;
  Color? _activeColor;
  Color? _inactiveColor;
  Color? _indicatorColor;
  Gradient? _gradient;
  BorderRadius _borderRadius = BorderRadius.zero;
  EdgeInsets _padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  EdgeInsets _margin = EdgeInsets.zero;
  double _height = 64.0;
  double _elevation = 4.0;
  double _blurAmount = 10.0;
  Color? _shadowColor;
  Border? _border;
  Duration _animationDuration = const Duration(milliseconds: 300);
  Curve _animationCurve = Curves.easeInOut;
  bool _hapticFeedback = true;
  double _iconSize = 24.0;
  double _activeIconSize = 26.0;
  TextStyle? _selectedLabelStyle;
  TextStyle? _unselectedLabelStyle;

  NavoraXNavBuilder();

  /// Start from an existing template configuration.
  factory NavoraXNavBuilder.fromConfig(NavoraXConfig base) {
    return NavoraXNavBuilder()
      ..id(base.id)
      ..name(base.name)
      ..category(base.category)
      ..shape(base.shape)
      ..indicator(base.indicator)
      ..animation(base.animation)
      ..iconStyle(base.iconStyle)
      ..labelStyle(base.labelStyle)
      ..background(base.backgroundStyle)
      ..backgroundColor(base.backgroundColor)
      ..activeColor(base.activeColor)
      ..inactiveColor(base.inactiveColor)
      ..indicatorColor(base.indicatorColor)
      ..gradient(base.gradient)
      ..borderRadius(base.borderRadius)
      ..padding(base.padding)
      ..margin(base.margin)
      ..height(base.height)
      ..elevation(base.elevation)
      ..blurAmount(base.blurAmount)
      ..shadowColor(base.shadowColor)
      ..border(base.border)
      ..animationDuration(base.animationDuration)
      ..animationCurve(base.animationCurve)
      ..hapticFeedback(base.hapticFeedback)
      ..iconSize(base.iconSize)
      ..activeIconSize(base.activeIconSize)
      ..selectedLabelStyle(base.selectedLabelStyle)
      ..unselectedLabelStyle(base.unselectedLabelStyle);
  }

  NavoraXNavBuilder id(String val) {
    _id = val;
    return this;
  }

  NavoraXNavBuilder name(String val) {
    _name = val;
    return this;
  }

  NavoraXNavBuilder category(NavoraXCategory val) {
    _category = val;
    return this;
  }

  NavoraXNavBuilder shape(NavoraXShape val) {
    _shape = val;
    return this;
  }

  NavoraXNavBuilder indicator(NavoraXIndicator val) {
    _indicator = val;
    return this;
  }

  NavoraXNavBuilder animation(NavoraXAnimation val) {
    _animation = val;
    return this;
  }

  NavoraXNavBuilder iconStyle(NavoraXIconStyle val) {
    _iconStyle = val;
    return this;
  }

  NavoraXNavBuilder labelStyle(NavoraXLabelStyle val) {
    _labelStyle = val;
    return this;
  }

  NavoraXNavBuilder background(NavoraXBackgroundStyle val) {
    _backgroundStyle = val;
    return this;
  }

  NavoraXNavBuilder backgroundColor(Color? val) {
    _backgroundColor = val;
    return this;
  }

  NavoraXNavBuilder activeColor(Color? val) {
    _activeColor = val;
    return this;
  }

  NavoraXNavBuilder inactiveColor(Color? val) {
    _inactiveColor = val;
    return this;
  }

  NavoraXNavBuilder indicatorColor(Color? val) {
    _indicatorColor = val;
    return this;
  }

  NavoraXNavBuilder gradient(Gradient? val) {
    _gradient = val;
    return this;
  }

  NavoraXNavBuilder borderRadius(dynamic val) {
    if (val is double) {
      _borderRadius = BorderRadius.circular(val);
    } else if (val is BorderRadius) {
      _borderRadius = val;
    }
    return this;
  }

  NavoraXNavBuilder padding(EdgeInsets val) {
    _padding = val;
    return this;
  }

  NavoraXNavBuilder margin(EdgeInsets val) {
    _margin = val;
    return this;
  }

  NavoraXNavBuilder height(double val) {
    _height = val;
    return this;
  }

  NavoraXNavBuilder elevation(double val) {
    _elevation = val;
    return this;
  }

  NavoraXNavBuilder blurAmount(double val) {
    _blurAmount = val;
    return this;
  }

  NavoraXNavBuilder shadowColor(Color? val) {
    _shadowColor = val;
    return this;
  }

  NavoraXNavBuilder border(Border? val) {
    _border = val;
    return this;
  }

  NavoraXNavBuilder animationDuration(Duration val) {
    _animationDuration = val;
    return this;
  }

  NavoraXNavBuilder animationCurve(Curve val) {
    _animationCurve = val;
    return this;
  }

  NavoraXNavBuilder hapticFeedback(bool val) {
    _hapticFeedback = val;
    return this;
  }

  NavoraXNavBuilder iconSize(double val) {
    _iconSize = val;
    return this;
  }

  NavoraXNavBuilder activeIconSize(double val) {
    _activeIconSize = val;
    return this;
  }

  NavoraXNavBuilder selectedLabelStyle(TextStyle? val) {
    _selectedLabelStyle = val;
    return this;
  }

  NavoraXNavBuilder unselectedLabelStyle(TextStyle? val) {
    _unselectedLabelStyle = val;
    return this;
  }

  /// Builds the immutable [NavoraXConfig] object.
  NavoraXConfig build() {
    return NavoraXConfig(
      id: _id,
      name: _name,
      category: _category,
      shape: _shape,
      indicator: _indicator,
      animation: _animation,
      iconStyle: _iconStyle,
      labelStyle: _labelStyle,
      backgroundStyle: _backgroundStyle,
      backgroundColor: _backgroundColor,
      activeColor: _activeColor,
      inactiveColor: _inactiveColor,
      indicatorColor: _indicatorColor,
      gradient: _gradient,
      borderRadius: _borderRadius,
      padding: _padding,
      margin: _margin,
      height: _height,
      elevation: _elevation,
      blurAmount: _blurAmount,
      shadowColor: _shadowColor,
      border: _border,
      animationDuration: _animationDuration,
      animationCurve: _animationCurve,
      hapticFeedback: _hapticFeedback,
      iconSize: _iconSize,
      activeIconSize: _activeIconSize,
      selectedLabelStyle: _selectedLabelStyle,
      unselectedLabelStyle: _unselectedLabelStyle,
    );
  }
}
