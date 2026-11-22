import 'package:flutter_test/flutter_test.dart';
import 'package:nagarsetu_flutter/main.dart';

void main() {
  testWidgets('NagarSetu smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NagarSetuApp());
    expect(find.text('NagarSetu'), findsWidgets);
  });
}
