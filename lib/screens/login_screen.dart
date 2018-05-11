import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackontraktfltr/models/auth_state.dart';
import 'package:trackontraktfltr/state_container.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _webViewPlugin = new FlutterWebviewPlugin();
  bool _loading = true;
  AuthState _authState;




  @override
  void initState() {
    super.initState();
    _authState = StateContainer.of(context).authState;
    _webViewPlugin.onStateChanged.listen((WebViewStateChanged event) {
      print(event.toString());
    });
    _webViewPlugin.onUrlChanged.listen((String url) {
      print("webview url changed $url");
      if (_authState.isRedirectUrl(url)) {
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
    if (await _authState.isAuthorized()) {
      //we already have login!
      setState(() {
        _loading = false;
      });
    } else {
      _webViewPlugin.launch(_authState.getAuthorizationUrl(),
          withJavascript: true, withLocalStorage: true);
    }
  }


  void _finishOauth(Uri redirected) async {
    print("finish oauth");
    await _authState.finishOauth2Authorization(redirected);
    //we are done.
    setState(() {
      _loading = false;
    });
  }



}

