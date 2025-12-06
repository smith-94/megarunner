import 'package:flutter_test/flutter_test.dart';
import 'package:megarunner/main.dart';

void main() {
  testWidgets('App widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // You can add more specific tests for your game here.
    // For example, checking if certain components are rendered.
  });
}
