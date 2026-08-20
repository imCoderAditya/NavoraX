import '../core/models/navorax_config.dart';

/// Abstract interface for AI providers (OpenAI, Gemini, Claude, Local AI, Custom API).
abstract class NavoraXAIProvider {
  Future<NavoraXConfig> generate(String prompt);
}

/// Typedef alias for backward compatibility.
typedef NavigationAIProvider = NavoraXAIProvider;
