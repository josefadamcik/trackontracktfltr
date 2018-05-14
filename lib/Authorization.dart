import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

class Authorization {
  final _authorizationEndpoint =
      Uri.parse("https://api.trakt.tv/oauth/authorize");
  final _tokenEndpoint = Uri.parse("https://api.trakt.tv/oauth/token");
  final _oauthCredentialsPreferencesKey = "oauthcred";
  final _redirectUrl = Uri.parse("tot://authorized");

  String _identifier;
  String _secret;
  oauth2.Client _client;
  var _grant;

  Future<bool> isAuthorized() async {
    await getOauthClient();
    return _client != null;
  }

  bool isRedirectUrl(String url) {
    return url.startsWith(_redirectUrl.toString());
  }

  String getAuthorizationUrl() {
    _provideAuthorizationCodeGrant()
        .getAuthorizationUrl(_redirectUrl)
        .toString();
  }

  /// Either load an OAuth2 client from saved credentials or authenticate a new
  /// one.
  Future<oauth2.Client> getOauthClient() async {
    if (_client == null) {
      var keys = await _loadKeys();
      _identifier = keys['clientid'];
      _secret = keys['clientsecret'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var credentialsJson = prefs.getString(_oauthCredentialsPreferencesKey);
      if (credentialsJson != null) {
        var credentials = oauth2.Credentials.fromJson(credentialsJson);
        _client = oauth2.Client(credentials,
            identifier: _identifier, secret: _secret);
      }
    }
    return _client;
  }

  Future<oauth2.Client> finishOauth2Authorization(Uri redirected) async {
    _client =
        await _grant.handleAuthorizationResponse(redirected.queryParameters);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        _oauthCredentialsPreferencesKey, _client.credentials.toJson());
    return _client;
  }

  oauth2.AuthorizationCodeGrant _provideAuthorizationCodeGrant() {
    if (_grant == null) {
      _grant = oauth2.AuthorizationCodeGrant(
          _identifier, _authorizationEndpoint, _tokenEndpoint,
          secret: _secret);
    }
    return _grant;
  }

  Future<Map<String, dynamic>> _loadKeys() async {
    var keysString = await rootBundle.loadString('assets/trakt_keys.json');
    return json.decode(keysString);
  }
}
