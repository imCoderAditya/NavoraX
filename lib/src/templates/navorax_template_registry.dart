import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';
import 'navorax_template.dart';
import 'navorax_template_definitions.dart';

/// Typedef alias for backward compatibility.
typedef TemplateRegistry = NavoraXTemplateRegistry;

/// Registry providing lookup, search, and category filtering across 1000+ NavoraX templates.
class NavoraXTemplateRegistry {
  static final List<NavoraXConfig> _allTemplates = [];

  /// Get configuration by [NavoraXTemplateEnum] enum.
  static NavoraXConfig get(NavoraXTemplateEnum template) {
    if (NavoraXTemplateDefinitions.primaryTemplates.containsKey(template)) {
      return NavoraXTemplateDefinitions.primaryTemplates[template]!;
    }
    return NavoraXTemplateDefinitions.getConfigForId(template.name);
  }

  /// Get configuration by template ID string (e.g. "glass_morph", "template_42").
  static NavoraXConfig getById(String id) {
    return NavoraXTemplateDefinitions.getConfigForId(id);
  }

  /// Filter templates by [NavoraXCategory].
  static List<NavoraXConfig> byCategory(NavoraXCategory category) {
    return all.where((config) => config.category == category).toList();
  }

  /// Search templates by name, category, shape, indicator, or animation keywords.
  static List<NavoraXConfig> search(String query) {
    if (query.trim().isEmpty) return all;
    final q = query.toLowerCase().trim();

    return all.where((config) {
      return config.id.toLowerCase().contains(q) ||
          config.name.toLowerCase().contains(q) ||
          config.category.name.toLowerCase().contains(q) ||
          config.shape.name.toLowerCase().contains(q) ||
          config.indicator.name.toLowerCase().contains(q) ||
          config.animation.name.toLowerCase().contains(q);
    }).toList();
  }

  /// Lazy-loaded list of 1000+ predefined templates.
  static List<NavoraXConfig> get all {
    if (_allTemplates.isEmpty) {
      for (final template in NavoraXTemplateEnum.values) {
        _allTemplates.add(get(template));
      }

      for (int i = _allTemplates.length; i < 1000; i++) {
        _allTemplates.add(NavoraXTemplateDefinitions.getConfigForId('template_$i'));
      }
    }
    return List.unmodifiable(_allTemplates);
  }
}
