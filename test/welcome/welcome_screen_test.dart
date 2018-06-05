import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trackontraktfltr/login/authorization.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/welcome/welcome_screen.dart';

class MockAuthorization extends Mock implements Authorization {}

void main() {
  final authorization = MockAuthorization();

  setUp(() {
    reset(authorization);
  });

  testWidgets('Authorized welcome screen has loader',
      (WidgetTester tester) async {
    when(authorization.isAuthorized()).thenReturn(Future<bool>.value(true));

    await tester.pumpWidget(provideAppWithWelcomeScreen(authorization));

    expectTrackOnTraktTitle();
    expectWelcomeMessage();
    expectProgressIndicator();

    await tester.pumpAndSettle();
    //fixme: assert navigation, somehow
  });

  testWidgets('Unauthorized welecome screen has a button.',
      (WidgetTester tester) async {
    when(authorization.isAuthorized()).thenReturn(Future<bool>.value(false));
    final app = provideAppWithWelcomeScreen(authorization);
    await tester.pumpWidget(app);

    expectTrackOnTraktTitle();
    expectWelcomeMessage();
    expectProgressIndicator();

    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);

    await tester.tap(find.byType(RaisedButton));
    //fixme: assert navigation, somehow
  });
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

MaterialApp provideAppWithWelcomeScreen(MockAuthorization authorization) {
  return MaterialApp(
    home: WelcomeScreen(authorization),
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
