import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trackontraktfltr/app_navigator.dart';
import 'package:trackontraktfltr/resources/routes.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/welcome/welcome_screen.dart';

import '../mock.dart';

void main() {
  final authorization = MockAuthorization();
  final appNavigator = MockAppNavigator();

  setUp(() {
    reset(authorization);
    reset(appNavigator);
  });

  testWidgets('Authorized welcome screen has loader',
      (WidgetTester tester) async {
    withUnauthorized(authorization: authorization);

    await tester
        .pumpWidget(withAppWithWelcomeScreen(authorization, appNavigator));

    expectTrackOnTraktTitle();
    expectWelcomeMessage();
    expectProgressIndicator();

    verify(appNavigator.showHistory());
  });

  testWidgets('Unauthorized welecome screen has a button.',
      (WidgetTester tester) async {
    withAuthorized(authorization: authorization);

    final app = withAppWithWelcomeScreen(authorization, appNavigator);
    await tester.pumpWidget(app);

    expectTrackOnTraktTitle();
    expectWelcomeMessage();
    expectProgressIndicator();

    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);

    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();

    verify(appNavigator.showNamed(Routes.login));
  });
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

MaterialApp withAppWithWelcomeScreen(
    MockAuthorization authorization, MockAppNavigator mockAppNavigator) {
  return MaterialApp(
    home:
        WelcomeScreen(authorization, TestAppNavigatorFactory(mockAppNavigator)),
  );
}

void expectProgressIndicator() {
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
}

void expectWelcomeMessage() {
  final expectedString = Strings.welcomeMessagePartA +
      Strings.welcomeMessageTraktTv +
      Strings.welcomeMessagePartB;
  expect(find.byWidgetPredicate((Widget w) {
    if (w is RichText) {
      return w.text.toPlainText() == expectedString;
    }
    return false;
  }), findsOneWidget);
}

void expectTrackOnTraktTitle() {
  expect(find.text('TrackOnTrakt'), findsOneWidget);
}
