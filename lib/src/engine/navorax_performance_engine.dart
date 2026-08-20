import 'package:flutter/foundation.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';

/// Typedef alias for backward compatibility.
typedef PerformanceEngine = NavoraXPerformanceEngine;

/// Engine responsible for device performance optimization and graphics scaling in NavoraX.
class NavoraXPerformanceEngine {
  /// Optimizes a [NavoraXConfig] according to the selected [NavoraXPerformanceMode].
  static NavoraXConfig optimize(
    NavoraXConfig config,
    NavoraXPerformanceMode mode,
  ) {
    if (mode == NavoraXPerformanceMode.high) {
      return config;
    }

    bool isLowPerformanceDevice = false;
    if (mode == NavoraXPerformanceMode.auto) {
      if (kIsWeb) {
        isLowPerformanceDevice = false;
      }
    } else if (mode == NavoraXPerformanceMode.low) {
      isLowPerformanceDevice = true;
    }

    if (isLowPerformanceDevice || mode == NavoraXPerformanceMode.low) {
      NavoraXBackgroundStyle optimizedBg = config.backgroundStyle;
      if (config.backgroundStyle == NavoraXBackgroundStyle.glass ||
          config.backgroundStyle == NavoraXBackgroundStyle.glassMorph) {
        optimizedBg = NavoraXBackgroundStyle.solid;
      }

      return config.copyWith(
        backgroundStyle: optimizedBg,
        blurAmount: 0.0,
        elevation: config.elevation > 4 ? 4 : config.elevation,
        animation: config.animation == NavoraXAnimation.liquid ||
                config.animation == NavoraXAnimation.gooey
            ? NavoraXAnimation.fade
            : config.animation,
      );
    }

    if (mode == NavoraXPerformanceMode.balanced) {
      return config.copyWith(
        blurAmount: config.blurAmount > 8.0 ? 8.0 : config.blurAmount,
      );
    }

    return config;
  }
}
