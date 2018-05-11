import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:trackontraktfltr/screens/history_screen.dart';
import 'package:trackontraktfltr/screens/login_screen.dart';
import 'package:trackontraktfltr/screens/welcome_screen.dart';
import 'package:trackontraktfltr/state_container.dart';

void main() => runApp(new StateContainer(child: new MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: new Color(0xFF1976d2),
        accentColor: new Color(0xFF008ba3),
        primaryColorLight: new Color(0xFF63a4ff),
        primaryColorDark: new Color(0xFF004ba0),
      ),
      home: new WelcomeScreen(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new LoginScreen(),
        '/history': (BuildContext context) => new HistoryScreen(),
      },
    );
  }
}

