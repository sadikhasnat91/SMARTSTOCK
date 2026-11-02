import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stock/main.dart';

void main() {
  testWidgets('SmartStock smoke test - renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartStockApp());
    expect(find.text('SmartStock'), findsWidgets);
    expect(find.text('Sign In'), findsWidgets);
  });
}
