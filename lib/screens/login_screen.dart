import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:trackontraktfltr/Authorization.dart';
import 'package:trackontraktfltr/routes.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return  _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _webViewPlugin = FlutterWebviewPlugin();
  final Authorization _authorization = Authorization();
  bool _loading = true;


  @override
  void initState() {
    super.initState();
    _webViewPlugin.onStateChanged.listen((WebViewStateChanged event) {
      print("webview ${event.toString()}");
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Login on Trakt.tv"),
      ),
      body: Center(
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
      _continue();
    } else {
      var url = _authorization.getAuthorizationUrl();
      print("Start webview for $url");
      _webViewPlugin.launch(url,
          withJavascript: true, withLocalStorage: true);
    }
  }

  void _continue() {
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.history, (Route<dynamic> route) => false);
  }


  void _finishOauth(Uri redirected) async {
    print("finish oauth");
    await _authorization.finishOauth2Authorization(redirected);
    _continue();
  }
}

