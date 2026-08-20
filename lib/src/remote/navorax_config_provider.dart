import 'dart:convert';
import '../core/models/navorax_config.dart';

/// Abstract provider for remote configurations in NavoraX.
abstract class NavoraXConfigProvider {
  Future<NavoraXConfig> load();
}

/// JSON implementation of [NavoraXConfigProvider].
class NavoraXJsonConfigProvider implements NavoraXConfigProvider {
  final String jsonSource;

  NavoraXJsonConfigProvider(this.jsonSource);

  @override
  Future<NavoraXConfig> load() async {
    final Map<String, dynamic> decoded = jsonDecode(jsonSource);
    return NavoraXConfig.fromJson(decoded);
  }
}

/// Typedef aliases for backward compatibility.
typedef NavigationConfigProvider = NavoraXConfigProvider;
typedef JsonNavigationConfigProvider = NavoraXJsonConfigProvider;
