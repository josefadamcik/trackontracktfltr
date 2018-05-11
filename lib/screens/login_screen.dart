import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trackontraktfltr/Authorization.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _webViewPlugin = new FlutterWebviewPlugin();
  final Authorization _authorization = new Authorization();
  bool _loading = true;




  @override
  void initState() {
    super.initState();
    _webViewPlugin.onStateChanged.listen((WebViewStateChanged event) {
      print(event.toString());
    });
    _webViewPlugin.onUrlChanged.listen((String url) {
      print("webview url changed $url");
      if (_authorization.isRedirectUrl(url)) {
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
    if (await _authorization.isAuthorized()) {
      print("Alerady authorized");
      //we already have login!
      setState(() {
        _loading = false;
      });
    } else {
      print("Start webview");
      _webViewPlugin.launch(_authorization.getAuthorizationUrl(),
          withJavascript: true, withLocalStorage: true);
    }
  }


  void _finishOauth(Uri redirected) async {
    print("finish oauth");
    await _authorization.finishOauth2Authorization(redirected);
    //we are done.
    setState(() {
      _loading = false;
    });
  }



}

