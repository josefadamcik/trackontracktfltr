import 'package:flutter/material.dart';
import 'package:trackontraktfltr/routes.dart';
import 'package:trackontraktfltr/screens/detail_screen.dart';
import 'package:trackontraktfltr/screens/history_screen.dart';
import 'package:trackontraktfltr/screens/login_screen.dart';
import 'package:trackontraktfltr/screens/welcome_screen.dart';
import 'package:trackontraktfltr/state_container.dart';
import 'package:trackontraktfltr/strings.dart';
import 'package:trackontraktfltr/style.dart';

void main() => runApp(StateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
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
      home: WelcomeScreen(),
      routes: <String, WidgetBuilder> {
        Routes.login: (BuildContext context) => LoginScreen(),
        Routes.history: (BuildContext context) => HistoryScreen(),
      },
      onGenerateRoute: (RouteSettings routeSettings) {
        if (routeSettings.name.startsWith(Routes.detailRoot)) {
          String idStr = routeSettings.name.replaceFirst(Routes.detailRoot, "");
          int id = int.parse(idStr);
          return MaterialPageRoute<void>(builder: (BuildContext context) {
            return DetailScreen(id);
          });
        }
      },
    );
  }
}

