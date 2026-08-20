import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navorax/navorax.dart';

void main() {
  group('NavoraXNavBuilder Tests', () {
    test('Fluent composer constructs expected NavoraXConfig', () {
      final config = NavoraXNavBuilder()
          .id('custom_1')
          .name('My Custom Nav')
          .category(NavoraXCategory.neumorphism)
          .shape(NavoraXShape.rounded)
          .indicator(NavoraXIndicator.dot)
          .animation(NavoraXAnimation.bounce)
          .backgroundColor(Colors.black)
          .activeColor(Colors.cyan)
          .elevation(12)
          .build();

      expect(config.id, 'custom_1');
      expect(config.category, NavoraXCategory.neumorphism);
      expect(config.shape, NavoraXShape.rounded);
      expect(config.indicator, NavoraXIndicator.dot);
      expect(config.animation, NavoraXAnimation.bounce);
      expect(config.backgroundColor, Colors.black);
      expect(config.activeColor, Colors.cyan);
      expect(config.elevation, 12);
    });
  });
}
