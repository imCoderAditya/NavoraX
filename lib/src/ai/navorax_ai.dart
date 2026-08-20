import 'package:flutter/material.dart';
import '../core/navorax_enums.dart';
import '../core/models/navorax_config.dart';
import '../templates/navorax_template.dart';
import '../templates/navorax_template_registry.dart';
import 'navorax_ai_provider.dart';

/// Typedef alias for backward compatibility.
typedef SmartNavAI = NavoraXAI;

/// Smart AI Navigation generator and provider manager for NavoraX.
class NavoraXAI {
  static NavoraXAIProvider? _provider;

  /// Register a custom AI Provider implementation.
  static void setProvider(NavoraXAIProvider provider) {
    _provider = provider;
  }

  /// Generate a [NavoraXConfig] from a natural language prompt.
  static Future<NavoraXConfig> generate(String prompt) async {
    if (_provider != null) {
      return await _provider!.generate(prompt);
    }
    // Heuristic fallback generator when no external AI provider is set
    return _heuristicGenerate(prompt);
  }

  static NavoraXConfig _heuristicGenerate(String prompt) {
    final lower = prompt.toLowerCase();

    if (lower.contains('glass') || lower.contains('frosted')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.glassMorph);
    }
    if (lower.contains('ecommerce') || lower.contains('shop') || lower.contains('cart')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.ecommerce);
    }
    if (lower.contains('gaming') || lower.contains('cyberpunk') || lower.contains('neon')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.cyberpunk);
    }
    if (lower.contains('gold') || lower.contains('luxury') || lower.contains('premium')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.royalGold);
    }
    if (lower.contains('ios') || lower.contains('apple')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.ios);
    }
    if (lower.contains('neumorphic') || lower.contains('soft')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.neumorphic);
    }
    if (lower.contains('floating') || lower.contains('pill')) {
      return NavoraXTemplateRegistry.get(NavoraXTemplateEnum.floatingPill);
    }

    // Default intelligent fallback
    return NavoraXConfig(
      id: 'ai_generated_${DateTime.now().millisecondsSinceEpoch}',
      name: 'AI Generated: "$prompt"',
      category: NavoraXCategory.modern,
      shape: NavoraXShape.pill,
      indicator: NavoraXIndicator.glow,
      animation: NavoraXAnimation.elastic,
      backgroundStyle: NavoraXBackgroundStyle.glassMorph,
      backgroundColor: const Color(0x331E1E2C),
      activeColor: const Color(0xFF6366F1),
      inactiveColor: const Color(0xFF94A3B8),
      indicatorColor: const Color(0xFF6366F1),
      borderRadius: BorderRadius.circular(30),
      margin: const EdgeInsets.all(12),
      height: 64,
      elevation: 8,
    );
  }
}
