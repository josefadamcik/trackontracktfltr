import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trackontraktfltr/Authorization.dart';
import 'package:trackontraktfltr/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _checkingIfAlreadyLoggedIn = true;
  Authorization _authorization = Authorization();

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  _onLoginButtonPressed() async {
    Navigator.of(context).pushNamed(Routes.login);
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

    return Scaffold(
      backgroundColor: Color(0xFF004ba0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/ic_big.png'),
                  Text('TrackOnTrakt',
                      style: theme.textTheme.display1.copyWith(
                          color: Color(0xFF00bcd4), fontFamily: 'Roboto-Slab'))
                ]),
          ),
          _buildWelcomeText(defaultTextStyle, underlinedStyle),
          Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                    child:
                      _checkingIfAlreadyLoggedIn ?
                      Row(children: <Widget>[CircularProgressIndicator()], mainAxisAlignment: MainAxisAlignment.center,)
                      : MaterialButton(
                          color: theme.accentColor,
                          textColor: Colors.white,
                          onPressed: () => _onLoginButtonPressed(),
                          child: Text("Login via trakt.tv"))))
          ])
        ],
      ),
    );
  }

  Container _buildWelcomeText(
      TextStyle defaultTextStyle, TextStyle underlinedStyle) {
    return Container(
      width: 304.0,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text:
                "TrackOnTrakt is an opensource Android application for tracking your watched movies and shows on the ",
            style: defaultTextStyle,
            children: <TextSpan>[
              TextSpan(
                  text: 'trakt.tv',
                  style: underlinedStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchTraktWebsite();
                    }),
              TextSpan(
                  style: defaultTextStyle,
                  text:
                      ' website. You need a trakt.tv account in order to use it.')
            ]),
      ),
    );
  }

  void _checkAuthorization() async {
    bool loggedIn = await _authorization.isAuthorized();
    if (loggedIn) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.history, (Route<dynamic> route) => false);
    } else {
      setState(() {
        _checkingIfAlreadyLoggedIn = false;
      });
    }
  }
}
