import 'package:flutter_test/flutter_test.dart';
import 'package:navorax/navorax.dart';

void main() {
  group('NavoraXConfig Serialization Tests', () {
    test('toJson and fromJson preserve properties', () {
      const config = NavoraXConfig(
        id: 'test_config',
        name: 'Test Config',
        category: NavoraXCategory.glassmorphism,
        shape: NavoraXShape.floating,
        indicator: NavoraXIndicator.glow,
        animation: NavoraXAnimation.elastic,
        height: 70,
        elevation: 8,
      );

      final json = config.toJson();
      expect(json['id'], 'test_config');
      expect(json['category'], 'glassmorphism');

      final reconstructed = NavoraXConfig.fromJson(json);
      expect(reconstructed.id, config.id);
      expect(reconstructed.category, config.category);
      expect(reconstructed.shape, config.shape);
    });

    test('NavoraXJsonConfigProvider parses json string', () async {
      const jsonStr = '''
      {
        "id": "remote_1",
        "name": "Remote Glass",
        "category": "glassmorphism",
        "shape": "pill",
        "indicator": "pill",
        "height": 65
      }
      ''';

      final provider = NavoraXJsonConfigProvider(jsonStr);
      final config = await provider.load();

      expect(config.id, 'remote_1');
      expect(config.shape, NavoraXShape.pill);
    });
  });
}
