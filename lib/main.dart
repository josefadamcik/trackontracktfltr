import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:trackontraktfltr/routes.dart';
import 'package:trackontraktfltr/screens/history_screen.dart';
import 'package:trackontraktfltr/screens/login_screen.dart';
import 'package:trackontraktfltr/screens/welcome_screen.dart';
import 'package:trackontraktfltr/state_container.dart';

void main() => runApp(StateContainer(child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1976d2),
        accentColor: Color(0xFF008ba3),
        primaryColorLight: Color(0xFF63a4ff),
        primaryColorDark: Color(0xFF004ba0),
      ),
      home: WelcomeScreen(),
      routes: <String, WidgetBuilder> {
        Routes.login: (BuildContext context) => LoginScreen(),
        Routes.history: (BuildContext context) => HistoryScreen(),
      },
    );
  }
}

