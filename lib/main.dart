import 'package:flutter/material.dart';
import 'package:trackontraktfltr/login_page.dart';
import 'package:trackontraktfltr/welcome_page.dart';
import 'package:flutter/painting.dart' show Color;

void main() => runApp(new MyApp());



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
      home: new WelcomePage(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new LoginPage(),
      },
    );
  }
}

