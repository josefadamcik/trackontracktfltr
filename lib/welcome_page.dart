import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "TrackOnTrakt";

  @override
  _MyWelcomePageState createState() => new _MyWelcomePageState();
}

class _MyWelcomePageState extends State<WelcomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var defaultTextStyle = Theme.of(context).primaryTextTheme.body1;
    var underlinedStyle = defaultTextStyle.copyWith(
        decoration: TextDecoration.underline, color: theme.accentColor);

    return new Scaffold(
      backgroundColor: new Color(0xFF004ba0),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Image.asset('assets/images/ic_big.png'),
                  new Text('TrackOnTrakt',
                      style: theme.textTheme.display1.copyWith(
                          color: new Color(0xFF00bcd4),
                          fontFamily: 'Roboto-Slab'))
                ]),
          ),
          _buildWelcomeText(defaultTextStyle, underlinedStyle),
          new Row(children: <Widget>[
            new Expanded(
                child: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    child: new MaterialButton(
                        color: theme.accentColor,
                        textColor: Colors.white,
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/login'),
                        child: new Text("Login via trakt.tv"))))
          ])
        ],
      ),
    );
  }

  Container _buildWelcomeText(
      TextStyle defaultTextStyle, TextStyle underlinedStyle) {
    return new Container(
        width: 304.0,
        padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: new RichText(
            textAlign: TextAlign.center,
            text: new TextSpan(
                text:
                    "TrackOnTrakt is an opensource Android application for tracking your watched movies and shows on the ",
                style: defaultTextStyle,
                children: <TextSpan>[
                  new TextSpan(text: 'trakt.tv',
                      style: underlinedStyle,
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () { _launchURL(); }
                  ),
                  new TextSpan(
                      style: defaultTextStyle,
                      text:
                          ' website. You need a trakt.tv account in order to use it.')
                ]),
          ),
          );
  }
}


_launchURL() async {
  const url = 'https://trakt.tv/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
