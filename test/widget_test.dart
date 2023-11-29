import 'package:flutter_test/flutter_test.dart';

import 'package:daily_routine/main.dart';

void main() {
  testWidgets('Welcome screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to your Daily Routine!'), findsOneWidget);
  });
}
