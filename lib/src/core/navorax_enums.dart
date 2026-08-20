/// Typedef aliases for backward compatibility.
typedef NavShape = NavoraXShape;
typedef NavIndicator = NavoraXIndicator;
typedef NavAnimation = NavoraXAnimation;
typedef NavIconStyle = NavoraXIconStyle;
typedef NavLabelStyle = NavoraXLabelStyle;
typedef NavBackgroundStyle = NavoraXBackgroundStyle;
typedef NavCategory = NavoraXCategory;
typedef NavigationContextMode = NavoraXContextMode;
typedef NavigationBehaviorMode = NavoraXBehaviorMode;
typedef NavigationPerformanceMode = NavoraXPerformanceMode;
typedef NavBadgeType = NavoraXBadgeType;

/// Navigation background shapes supported by NavoraX.
enum NavoraXShape {
  flat,
  rounded,
  pill,
  floating,
  dock,
  curved,
  notched,
  liquid,
  bubble,
  wave,
  stadium,
  capsule,
  hexagon,
  asymmetric,
}

/// Active selection indicator styles in NavoraX.
enum NavoraXIndicator {
  none,
  lineTop,
  lineBottom,
  dot,
  pill,
  glow,
  backgroundFill,
  liquidBubble,
  floatingBar,
  stretchy,
  sparkle,
  ring,
}

/// Animation styles for transitions and item interactions in NavoraX.
enum NavoraXAnimation {
  none,
  fade,
  slide,
  scale,
  bounce,
  elastic,
  spring,
  ripple,
  liquid,
  morph,
  gooey,
  magnetic,
  rotate,
  flip,
  wave,
  pulse,
  expand,
  shrink,
}

/// Visual styling mode for icons in NavoraX.
enum NavoraXIconStyle {
  standard,
  filled,
  outlined,
  animatedScale,
  animatedRotate,
  dualTone,
  glowing,
  bounce,
}

/// Visibility and animation behavior for labels in NavoraX.
enum NavoraXLabelStyle {
  alwaysShow,
  selectedOnly,
  neverShow,
  animatedSlide,
  animatedFade,
  tooltipStyle,
}

/// Background material/rendering mode in NavoraX.
enum NavoraXBackgroundStyle {
  solid,
  gradient,
  glass,
  glassMorph,
  neumorphicFlat,
  neumorphicConvex,
  neumorphicConcave,
  transparent,
}

/// Broad design template categories in NavoraX.
enum NavoraXCategory {
  minimal,
  modern,
  material3,
  ios,
  glassmorphism,
  neumorphism,
  floating,
  curved,
  liquid,
  bubble,
  pill,
  dock,
  gradient,
  animated,
  elastic,
  morphing,
  gooey,
  magnetic,
  premium,
  luxury,
  gaming,
  ecommerce,
  banking,
  socialMedia,
  dashboard,
  travel,
  foodDelivery,
  evCharging,
  media,
  productivity,
  education,
  healthcare,
  finance,
}

/// Screen / application runtime context modes for context-aware navigation in NavoraX.
enum NavoraXContextMode {
  normal,
  checkout,
  videoPlayer,
  charging,
  formFilling,
  focus,
  compact,
  hidden,
}

/// Smart interaction behavior modes in NavoraX.
enum NavoraXBehaviorMode {
  standard,
  adaptive,
  frequentHighlight,
  autoCompact,
}

/// Rendering performance optimization modes in NavoraX.
enum NavoraXPerformanceMode {
  auto,
  high,
  balanced,
  low,
}

/// Badge types for NavoraX nav items.
enum NavoraXBadgeType {
  count,
  dot,
  text,
  custom,
}
