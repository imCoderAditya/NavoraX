import 'package:flutter/foundation.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';
import '../templates/navorax_template.dart';
import '../templates/navorax_template_registry.dart';

/// Typedef aliases for backward compatibility and intuitive brand usage.
typedef SmartNavigation = NavoraXController;
typedef NavoraXNavigation = NavoraXController;

/// Global NavoraX controller managing live template switching, context changes,
/// and runtime morphing without rebuilding the full widget tree.
class NavoraXController {
  static final ValueNotifier<NavoraXContextMode> contextNotifier =
      ValueNotifier<NavoraXContextMode>(NavoraXContextMode.normal);

  static final ValueNotifier<NavoraXConfig?> configNotifier =
      ValueNotifier<NavoraXConfig?>(null);

  /// Change runtime context (e.g. checkout, videoPlayer, charging).
  static void setContext(NavoraXContextMode mode) {
    contextNotifier.value = mode;
  }

  /// Change runtime template by [NavoraXTemplateEnum] enum.
  static void setTemplate(NavoraXTemplateEnum template) {
    configNotifier.value = NavoraXTemplateRegistry.get(template);
  }

  /// Change runtime template by template ID string.
  static void changeTemplate(NavoraXTemplateEnum template) {
    setTemplate(template);
  }

  /// Set explicit custom [NavoraXConfig].
  static void setConfig(NavoraXConfig config) {
    configNotifier.value = config;
  }

  /// Current active context mode.
  static NavoraXContextMode get currentContext => contextNotifier.value;

  /// Current global active config.
  static NavoraXConfig? get currentConfig => configNotifier.value;
}
