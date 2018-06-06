import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trackontraktfltr/app_navigator.dart';
import 'package:trackontraktfltr/login/authorization.dart';
import 'package:trackontraktfltr/resources/routes.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/welcome/welcome_screen.dart';

class MockAuthorization extends Mock implements Authorization {}

class MockAppNavigator extends Mock implements AppNavigator {}

void main() {
  final authorization = MockAuthorization();
  final appNavigator = MockAppNavigator();

  setUp(() {
    reset(authorization);
    reset(appNavigator);
  });

  testWidgets('Authorized welcome screen has loader',
      (WidgetTester tester) async {
    when(authorization.isAuthorized()).thenReturn(Future<bool>.value(true));

    await tester
        .pumpWidget(provideAppWithWelcomeScreen(authorization, appNavigator));

    expectTrackOnTraktTitle();
    expectWelcomeMessage();
    expectProgressIndicator();

    verify(appNavigator.showHistory());
  });

  testWidgets('Unauthorized welecome screen has a button.',
      (WidgetTester tester) async {
    when(authorization.isAuthorized()).thenReturn(Future<bool>.value(false));
    final app = provideAppWithWelcomeScreen(authorization, appNavigator);
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

MaterialApp provideAppWithWelcomeScreen(
    MockAuthorization authorization, MockAppNavigator mockAppNavigator) {
  return MaterialApp(
    home:
        WelcomeScreen(authorization, TestAppNavigatorFactory(mockAppNavigator)),
    routes: <String, WidgetBuilder>{
      '/history': (BuildContext context) => EmptyWidget(),
      '/login': (BuildContext context) => EmptyWidget()
    },
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
