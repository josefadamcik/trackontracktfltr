import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _authorizationEndpoint =
      Uri.parse("https://api.trakt.tv/oauth/authorize");
  final _tokenEndpoint = Uri.parse("https://api.trakt.tv/oauth/token");
  final _oauthCredentialsPreferencesKey = "oauthcred";
  final _redirectUrl = Uri.parse("tot://authorized");
  final _webViewPlugin = new FlutterWebviewPlugin();


  String _identifier;
  String _secret;
  oauth2.Client _client;
  bool _loading = true;
  oauth2.AuthorizationCodeGrant _grant;




  @override
  void initState() {
    super.initState();
    _webViewPlugin.onStateChanged.listen((WebViewStateChanged event) {
      print(event.toString());
    });
    _webViewPlugin.onUrlChanged.listen((String url) {
      print("webview url changed $url");
      if (url.startsWith(_redirectUrl.toString())) {
        _webViewPlugin.close();
        _finishOauth(Uri.parse(url));
      }
    });
    _initOauth();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login on Trakt.tv"),
      ),
      body: new Center(
          child: _loading ? CircularProgressIndicator() : Text("Logged in")),
    );
  }




  void _initOauth() async {
    _client = await _getOauthClient();
    if (_client == null) {
      _authorizeInWebview();
    } else {
      //we already have login!
      setState(() {
        _loading = false;
      });
    }
  }

  void _authorizeInWebview() async {
    _grant = new oauth2.AuthorizationCodeGrant(
        _identifier, _authorizationEndpoint, _tokenEndpoint,
        secret: _secret);

    _webViewPlugin.launch(_grant.getAuthorizationUrl(_redirectUrl).toString(),
        withJavascript: true, withLocalStorage: true);
  }

  void _finishOauth(Uri redirected) async {
    print("finish oauth");
    _client =
        await _grant.handleAuthorizationResponse(redirected.queryParameters);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _oauthCredentialsPreferencesKey, _client.credentials.toJson());
    //we are done.
    setState(() {
      _loading = false;
    });
  }


  Future<Map<String, dynamic>> _loadKeys() async {
    var keysString =  await rootBundle.loadString('assets/trakt_keys.json');
    return json.decode(keysString);
  }

  /// Either load an OAuth2 client from saved credentials or authenticate a new
  /// one.
  Future<oauth2.Client> _getOauthClient() async {
    var keys = await _loadKeys();
    _identifier = keys['clientid'];
    _secret = keys['clientsecret'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var credentialsJson = prefs.getString(_oauthCredentialsPreferencesKey);
    if (credentialsJson != null) {
      var credentials = new oauth2.Credentials.fromJson(credentialsJson);
      return new oauth2.Client(credentials,
          identifier: _identifier, secret: _secret);
    } else {
      return null;
    }
  }
}

