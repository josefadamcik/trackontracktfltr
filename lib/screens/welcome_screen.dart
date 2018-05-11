
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => new _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  _onLoginButtonPressed() async {
    Navigator.of(context).pushNamed('/login');
  }

  _launchTraktWebsite() async {
    const url = 'https://trakt.tv/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                        onPressed: () => _onLoginButtonPressed(),
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
                        ..onTap = () { _launchTraktWebsite(); }
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






