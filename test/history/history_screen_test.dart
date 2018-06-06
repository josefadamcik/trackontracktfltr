import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trackontraktfltr/history/history_item.dart';
import 'package:trackontraktfltr/history/history_screen.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/trakt_api.dart';

import '../mock.dart';

class MockTraktApi extends Mock implements TraktApi {}

void main() {
  final authorization = MockAuthorization();
  final appNavigator = MockAppNavigator();
  final traktApi = MockTraktApi();

  setUp(() {
    reset(authorization);
    reset(appNavigator);
    reset(traktApi);
  });

  testWidgets('Empty list', (WidgetTester tester) async {
    withAuthorized(authorization: authorization);

    final apiCallCompleter = Completer<List<HistoryItem>>();

    when(traktApi.myHistory(typed(any), typed(any)))
        .thenReturn(apiCallCompleter.future);

    await tester
        .pumpWidget(MaterialApp(home: HistoryScreen(traktApi, authorization)));

    expect(find.widgetWithText(AppBar, Strings.appName), findsOneWidget);

    //loading progress displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //api returns result
    apiCallCompleter.complete(List<HistoryItem>());
    await tester.pumpAndSettle();

    //no progress
    expect(find.byType(CircularProgressIndicator), findsNothing);

    //todo: some message that view is empty
//    expect(find.byWidgetPredicate((Widget w) {
//      return (w is ListView); // && w.childrenDelegate.estimatedChildCount == 0;
//    }), findsOneWidget);
  });
}
