import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:trackontraktfltr/app_navigator.dart';
import 'package:trackontraktfltr/login/authorization.dart';

class MockAppNavigator extends Mock implements AppNavigator {}

class MockAuthorization extends Mock implements Authorization {}

void withAuthorized({authorization: MockAuthorization}) {
  when(authorization.isAuthorized()).thenReturn(Future<bool>.value(false));
  when(authorization.getAccessToken())
      .thenReturn(Future<String>.value("testtoken"));
}

void withUnauthorized({authorization: MockAuthorization}) {
  when(authorization.isAuthorized()).thenReturn(Future<bool>.value(true));
}
