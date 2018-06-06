import 'package:flutter/widgets.dart';
import 'package:trackontraktfltr/models/media.dart';
import 'package:trackontraktfltr/resources/routes.dart';

class AppNavigatorFactory {
  AppNavigator get(BuildContext context) =>
      AppNavigator._forNavigator(Navigator.of(context));
}

class TestAppNavigatorFactory extends AppNavigatorFactory {
  final AppNavigator mockAppNavigator;

  TestAppNavigatorFactory(this.mockAppNavigator);

  @override
  AppNavigator get(BuildContext context) => mockAppNavigator;
}

class AppNavigator {
  NavigatorState _flutterNavigator;
  AppNavigator._forNavigator(this._flutterNavigator);

  void showNamed(String route) {
    _flutterNavigator.pushNamed(route);
  }

  void showMediaDetail(MediaItem mediaItem) {
    _flutterNavigator.push(Routes.detail(mediaItem));
  }

  void showHistory() {
    _flutterNavigator.pushNamedAndRemoveUntil(
        Routes.history, (Route<dynamic> route) => false);
  }
}
