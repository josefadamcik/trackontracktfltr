// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:trackontraktfltr/login/authorization.dart';
import 'package:trackontraktfltr/main.dart';

void main() {
  testWidgets('Start app and show welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(authorization: Authorization(),));

    expect(find.text('TrackOnTrakt'), findsOneWidget);

    // Verify that our counter has incremented.
  });
}
