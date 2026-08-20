import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navorax/navorax.dart';

void main() {
  group('NavoraX Widget Tests', () {
    testWidgets('Renders items and triggers onChanged tap callback',
        (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NavoraX(
              currentIndex: selectedIndex,
              items: const [
                NavoraXItem(icon: Icons.home, label: 'Home'),
                NavoraXItem(icon: Icons.search, label: 'Search'),
                NavoraXItem(icon: Icons.person, label: 'Profile'),
              ],
              onChanged: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('Does not throw overflow error in tight vertical constraints',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: SizedBox(
              height: 36,
              child: NavoraX(
                currentIndex: 0,
                config: const NavoraXConfig(
                  id: 'tight',
                  name: 'Tight Nav',
                  height: 36,
                  iconSize: 20,
                  activeIconSize: 22,
                ),
                items: const [
                  NavoraXItem(icon: Icons.home, label: 'Home'),
                  NavoraXItem(icon: Icons.search, label: 'Search'),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders center FAB action when provided',
        (WidgetTester tester) async {
      bool fabTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NavoraX(
              currentIndex: 0,
              items: const [
                NavoraXItem(icon: Icons.home, label: 'Home'),
                NavoraXItem(icon: Icons.person, label: 'Profile'),
              ],
              centerAction: NavoraXCenterAction(
                icon: Icons.add,
                onTap: () {
                  fabTapped = true;
                },
              ),
              onChanged: (index) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(fabTapped, isTrue);
    });

    test('NavoraXAI heuristic generator returns valid config', () async {
      final config = await NavoraXAI.generate('Build a frosted glass nav bar');
      expect(config.category, NavoraXCategory.glassmorphism);
    });
  });
}
