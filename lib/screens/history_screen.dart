import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackontraktfltr/authorization.dart';
import 'package:trackontraktfltr/models/history_item.dart';
import 'package:trackontraktfltr/trakt_api.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _traktApi = TraktApi();
  final _authorization = Authorization();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TrackOnTrakt history"),),
      body: FutureBuilder<List<HistoryItem>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Row(children: <Widget>[
                    Text(snapshot?.data[index]?.title ?? "title n/a")
                  ],);
                }
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("${snapshot.error}"));
            }

            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
      )
    );
  }

  Future<List<HistoryItem>> _loadData() async {
    final oauthClient = await _authorization.getOauthClient();
    return _traktApi.myHistory(oauthClient.credentials.accessToken, _authorization.identifier);
  }
}
