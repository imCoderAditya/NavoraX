import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_center_action.dart';
import '../core/models/navorax_item.dart';
import '../core/models/navorax_config.dart';
import '../core/theme/navorax_theme.dart';
import '../engine/navorax_adaptive_engine.dart';
import '../engine/navorax_animation_engine.dart';
import '../engine/navorax_engine.dart';
import '../engine/navorax_performance_engine.dart';
import '../templates/navorax_template.dart';
import '../templates/navorax_template_registry.dart';
import 'navorax_item_widget.dart';
import 'navorax_controller.dart';

/// Typedef aliases for brand name consistency and backward compatibility.
typedef NavoraXBottomNav = NavoraX;
typedef SmartBottomNav = NavoraX;

/// Highly customizable, production-ready Bottom Navigation Widget for Flutter.
class NavoraX extends StatefulWidget {
  final int currentIndex;
  final List<NavoraXItem> items;
  final ValueChanged<int> onChanged;
  final NavoraXTemplateEnum? template;
  final NavoraXConfig? config;
  final NavoraXCenterAction? centerAction;
  final bool adaptive;
  final bool contextAware;
  final NavoraXBehaviorMode behaviorMode;
  final NavoraXPerformanceMode performanceMode;
  final bool gestureMorphing;
  final bool useSafeArea;

  const NavoraX({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onChanged,
    this.template,
    this.config,
    this.centerAction,
    this.adaptive = false,
    this.contextAware = false,
    this.behaviorMode = NavoraXBehaviorMode.standard,
    this.performanceMode = NavoraXPerformanceMode.auto,
    this.gestureMorphing = false,
    this.useSafeArea = true,
  });

  /// Factory constructor taking a [NavoraXConfig] builder function.
  factory NavoraX.builder({
    Key? key,
    required int currentIndex,
    required List<NavoraXItem> items,
    required ValueChanged<int> onChanged,
    required NavoraXConfig Function() builder,
    NavoraXCenterAction? centerAction,
    bool adaptive = false,
    bool contextAware = false,
    NavoraXPerformanceMode performanceMode = NavoraXPerformanceMode.auto,
    bool useSafeArea = true,
  }) {
    return NavoraX(
      key: key,
      currentIndex: currentIndex,
      items: items,
      onChanged: onChanged,
      config: builder(),
      centerAction: centerAction,
      adaptive: adaptive,
      contextAware: contextAware,
      performanceMode: performanceMode,
      useSafeArea: useSafeArea,
    );
  }

  @override
  State<NavoraX> createState() => _NavoraXState();
}

class _NavoraXState extends State<NavoraX>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _indicatorPosition = 0.0;
  NavoraXConfig? _activeConfigOverride;
  bool _isCollapsedGesture = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _indicatorPosition = widget.currentIndex.toDouble();

    NavoraXController.configNotifier.addListener(_handleGlobalConfigChange);
    NavoraXController.contextNotifier.addListener(_handleGlobalContextChange);
  }

  @override
  void didUpdateWidget(NavoraX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animateIndicatorTo(widget.currentIndex.toDouble());
    }
  }

  @override
  void dispose() {
    NavoraXController.configNotifier.removeListener(_handleGlobalConfigChange);
    NavoraXController.contextNotifier.removeListener(_handleGlobalContextChange);
    _animController.dispose();
    super.dispose();
  }

  void _handleGlobalConfigChange() {
    if (NavoraXController.currentConfig != null) {
      setState(() {
        _activeConfigOverride = NavoraXController.currentConfig;
      });
    }
  }

  void _handleGlobalContextChange() {
    if (widget.contextAware) {
      setState(() {});
    }
  }

  void _animateIndicatorTo(double target) {
    final start = _indicatorPosition;
    final tween = Tween<double>(begin: start, end: target);
    final animation = tween.animate(
      CurvedAnimation(
        parent: _animController,
        curve: _getEffectiveConfig().animationCurve,
      ),
    );

    animation.addListener(() {
      setState(() {
        _indicatorPosition = animation.value;
      });
    });

    _animController.forward(from: 0.0);
  }

  NavoraXConfig _getEffectiveConfig() {
    if (_activeConfigOverride != null) {
      return _activeConfigOverride!;
    }
    if (widget.config != null) {
      return widget.config!;
    }
    if (widget.template != null) {
      return NavoraXTemplateRegistry.get(widget.template!);
    }
    return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.classic);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    // 1. Resolve base config
    NavoraXConfig resolvedConfig = _getEffectiveConfig();

    // 2. Check context-aware overrides
    if (widget.contextAware) {
      final currentCtx = NavoraXController.currentContext;
      if (currentCtx == NavoraXContextMode.hidden) {
        return const SizedBox.shrink();
      }
      if (currentCtx == NavoraXContextMode.checkout) {
        resolvedConfig = resolvedConfig.copyWith(
          shape: NavoraXShape.pill,
          backgroundStyle: NavoraXBackgroundStyle.solid,
          elevation: 2,
        );
      } else if (currentCtx == NavoraXContextMode.compact) {
        resolvedConfig = resolvedConfig.copyWith(
          height: 48,
          labelStyle: NavoraXLabelStyle.neverShow,
        );
      }
    }

    // 3. Inherited theme overrides
    final themeOverride = NavoraXTheme.of(context);
    if (themeOverride != null) {
      resolvedConfig = resolvedConfig.copyWith(
        backgroundColor: themeOverride.backgroundColor,
        activeColor: themeOverride.activeColor,
        inactiveColor: themeOverride.inactiveColor,
        indicatorColor: themeOverride.indicatorColor,
        selectedLabelStyle: themeOverride.selectedLabelStyle,
        unselectedLabelStyle: themeOverride.unselectedLabelStyle,
        borderRadius: themeOverride.borderRadius,
        height: themeOverride.height,
        elevation: themeOverride.elevation,
      );
    }

    // 4. Adaptive Engine
    final adaptedConfig = NavoraXAdaptiveEngine.adapt(
      resolvedConfig,
      context,
      enableAdaptive: widget.adaptive,
    );

    // 5. Performance Engine
    final finalConfig = NavoraXPerformanceEngine.optimize(
      adaptedConfig,
      widget.performanceMode,
    );

    // 6. Mobile Safe Area & Gesture Bar Inset Calculation
    final bottomInset = widget.useSafeArea
        ? MediaQuery.of(context).padding.bottom
        : 0.0;

    final bool isFloatingShape = finalConfig.shape == NavoraXShape.floating ||
        finalConfig.shape == NavoraXShape.pill ||
        finalConfig.shape == NavoraXShape.dock ||
        finalConfig.shape == NavoraXShape.capsule ||
        finalConfig.shape == NavoraXShape.stadium ||
        finalConfig.shape == NavoraXShape.hexagon ||
        finalConfig.shape == NavoraXShape.asymmetric;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final decor = NavoraXEngine.buildDecoration(
      backgroundStyle: finalConfig.backgroundStyle,
      backgroundColor: finalConfig.backgroundColor,
      gradient: finalConfig.gradient,
      borderRadius: finalConfig.borderRadius,
      elevation: finalConfig.elevation,
      shadowColor: finalConfig.shadowColor,
      border: finalConfig.border,
      isDark: isDark,
    );

    Widget navBarBody = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Selection Indicator Painter
        Positioned.fill(
          child: CustomPainterWidget(
            position: _indicatorPosition,
            count: widget.items.length,
            indicator: finalConfig.indicator,
            color: finalConfig.indicatorColor ??
                finalConfig.activeColor ??
                Colors.blue,
          ),
        ),

        // Navigation Items Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final isSelected = index == widget.currentIndex;

            // Handle center FAB gap if center action is present
            if (widget.centerAction != null &&
                widget.centerAction!.isNotched &&
                index == (widget.items.length ~/ 2) &&
                widget.items.length % 2 == 0) {
              return const SizedBox(width: 48);
            }

            return NavoraXItemWidget(
              item: item,
              isSelected: isSelected,
              config: finalConfig,
              animation: _animController,
              onTap: () {
                if (finalConfig.hapticFeedback) {
                  HapticFeedback.selectionClick();
                }
                widget.onChanged(index);
              },
            );
          }),
        ),
      ],
    );

    // Dynamic Height Calculation with Safe Area Inset
    final baseHeight = _isCollapsedGesture ? 44.0 : finalConfig.height;
    final totalContainerHeight =
        isFloatingShape ? baseHeight : baseHeight + bottomInset;

    final containerPadding = isFloatingShape
        ? finalConfig.padding
        : finalConfig.padding.copyWith(
            bottom: finalConfig.padding.bottom + bottomInset,
          );

    // Apply clip path for custom shapes
    final clipper = NavoraXEngine.getClipper(finalConfig.shape);
    Widget contentWidget = ClipPath(
      clipper: clipper,
      child: Container(
        height: totalContainerHeight,
        padding: containerPadding,
        decoration: decor,
        child: navBarBody,
      ),
    );

    // Glass backdrop blur filter
    if ((finalConfig.backgroundStyle == NavoraXBackgroundStyle.glass ||
            finalConfig.backgroundStyle == NavoraXBackgroundStyle.glassMorph) &&
        finalConfig.blurAmount > 0) {
      contentWidget = ClipPath(
        clipper: clipper,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: finalConfig.blurAmount,
            sigmaY: finalConfig.blurAmount,
          ),
          child: contentWidget,
        ),
      );
    }

    // Wrap with outer Stack to allow Center FAB floating above without ClipPath truncation
    if (widget.centerAction != null) {
      contentWidget = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          contentWidget,
          Positioned(
            top: widget.centerAction!.isNotched ? -16 : 0,
            child: GestureDetector(
              onTap: widget.centerAction!.onTap,
              behavior: HitTestBehavior.opaque,
              child: widget.centerAction!.customWidget ??
                  Container(
                    width: widget.centerAction!.size,
                    height: widget.centerAction!.size,
                    decoration: BoxDecoration(
                      shape: widget.centerAction!.shape,
                      color: widget.centerAction!.backgroundColor ??
                          finalConfig.activeColor ??
                          Colors.blue,
                      gradient: widget.centerAction!.gradient,
                      boxShadow: widget.centerAction!.elevation > 0
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: widget.centerAction!.elevation * 2,
                                offset: Offset(0, widget.centerAction!.elevation),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.centerAction!.icon,
                      color: widget.centerAction!.iconColor ?? Colors.white,
                      size: 28,
                    ),
                  ),
            ),
          ),
        ],
      );
    }

    // Outer Margin: for floating shapes, extend bottom margin by bottomInset so floating dock sits above gesture bar
    final outerMargin = isFloatingShape
        ? finalConfig.margin.copyWith(
            bottom: finalConfig.margin.bottom + bottomInset,
          )
        : finalConfig.margin;

    Widget resultWidget = Padding(
      padding: outerMargin,
      child: contentWidget,
    );

    if (widget.gestureMorphing) {
      resultWidget = GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < -200) {
              // Swipe up -> expand floating dock
              setState(() {
                _isCollapsedGesture = false;
              });
            } else if (details.primaryVelocity! > 200) {
              // Swipe down -> compact state
              setState(() {
                _isCollapsedGesture = true;
              });
            }
          }
        },
        child: resultWidget,
      );
    }

    return AnimatedContainer(
      duration: NavoraXAnimationEngine.getDuration(finalConfig.animation),
      curve: NavoraXAnimationEngine.getCurve(finalConfig.animation),
      child: resultWidget,
    );
  }
}

/// Custom painter helper widget bridging [ActiveIndicatorPainter].
class CustomPainterWidget extends StatelessWidget {
  final double position;
  final int count;
  final NavoraXIndicator indicator;
  final Color color;

  const CustomPainterWidget({
    super.key,
    required this.position,
    required this.count,
    required this.indicator,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ActiveIndicatorPainter(
        position: position,
        count: count,
        indicator: indicator,
        color: color,
      ),
    );
  }
}
