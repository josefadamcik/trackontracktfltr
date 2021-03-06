import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:trackontraktfltr/app_navigator.dart';
import 'package:trackontraktfltr/history/history_screen.dart';
import 'package:trackontraktfltr/login/authorization.dart';
import 'package:trackontraktfltr/login/login_screen.dart';
import 'package:trackontraktfltr/resources/routes.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/resources/style.dart';
import 'package:trackontraktfltr/state_container.dart';
import 'package:trackontraktfltr/trakt_api.dart';
import 'package:trackontraktfltr/welcome/welcome_screen.dart';

void main() => runApp(StateContainer(
        child: MyApp(
      authorization: Authorization(),
      traktApi: TraktApi(),
    )));

class MyApp extends StatelessWidget {
  final Authorization authorization;
  final TraktApi traktApi;

  const MyApp({
    Key key,
    @required this.authorization,
    @required this.traktApi,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppStyle.primaryColor,
        primaryColorLight: AppStyle.primaryColorLight,
        primaryColorDark: AppStyle.primaryColorDark,
        accentColor: AppStyle.accentColor,
      ),
      home: WelcomeScreen(authorization, AppNavigatorFactory()),
      routes: <String, WidgetBuilder>{
        Routes.login: (BuildContext context) => LoginScreen(),
        Routes.history: (BuildContext context) =>
            HistoryScreen(traktApi, authorization),
        //for more navigation options check Routes class
      },
    );
  }
}
