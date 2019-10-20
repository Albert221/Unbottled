import 'package:flutter_test/flutter_test.dart';
import 'package:unbottled/app.dart';

void main() {
  testWidgets('App starts up', (WidgetTester tester) async {
    await tester.pumpWidget(UnbottledApp());

    expect(find.text('Unbottled'), findsWidgets);
  });
}
