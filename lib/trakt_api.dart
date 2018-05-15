import 'dart:_http';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackontraktfltr/models/history_item.dart';


class TraktApi {
  static const String baseUrl = 'https://api.trakt.tv';
  static const String history = '/users/me/history';
  Future<List<HistoryItem>> myHistory(String token, String apiKey) async {
    final http.Response response = await http.get(baseUrl + history,
      headers: {
        HttpHeaders.AUTHORIZATION: "Bearer $token",
        HttpHeaders.USER_AGENT: "TrackOnTrakt fltr",
        HttpHeaders.CONTENT_TYPE: "application/json",
        "trakt-api-version": "2",
        "trakt-api-key": apiKey
      },
    );

    List<HistoryItem> resultList = List<HistoryItem>();
    if (response.statusCode != 200) {
      throw Exception("API returned ${response.statusCode} ${response.reasonPhrase}");
    }
    final body = response.body;
    print(body);
    final responseJson = json.decode(body);
    for (var item in responseJson) {
      resultList.add(HistoryItem.fromJson(item));
    }
    return resultList;
  }
}

