import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('NavoraX gallery app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NavoraXDemoApp());
    expect(find.byType(NavoraXDemoApp), findsOneWidget);
  });
}
