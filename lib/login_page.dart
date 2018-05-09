import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<String> loadKeysFile() async {
  return await rootBundle.loadString('keys.properties');
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text("Login"),
        ),
        body: new Center()
    );
  }
}
