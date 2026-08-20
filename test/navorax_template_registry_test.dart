import 'package:flutter_test/flutter_test.dart';
import 'package:navorax/navorax.dart';

void main() {
  group('NavoraXTemplateRegistry Tests', () {
    test('Template registry contains 1000+ templates', () {
      final templates = NavoraXTemplateRegistry.all;
      expect(templates.length, greaterThanOrEqualTo(1000));
    });

    test('Lookup by NavoraXTemplateEnum returns valid config', () {
      final config = NavoraXTemplateRegistry.get(NavoraXTemplateEnum.glassMorph);
      expect(config.id, 'glass_morph');
      expect(config.shape, NavoraXShape.floating);
    });

    test('Lookup by ID string works', () {
      final config = NavoraXTemplateRegistry.getById('cyberpunk');
      expect(config.category, NavoraXCategory.gaming);
      expect(config.shape, NavoraXShape.asymmetric);
    });

    test('Lookup by category filters correctly', () {
      final glassTemplates =
          NavoraXTemplateRegistry.byCategory(NavoraXCategory.glassmorphism);
      expect(glassTemplates, isNotEmpty);
      expect(
        glassTemplates.every((t) => t.category == NavoraXCategory.glassmorphism),
        isTrue,
      );
    });

    test('Search returns matching templates', () {
      final matches = NavoraXTemplateRegistry.search('glass');
      expect(matches, isNotEmpty);
    });

    test('Lookup synthetic template returns valid config', () {
      final config = NavoraXTemplateRegistry.getById('template_500');
      expect(config.id, 'template_500');
    });
  });
}
