import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackontraktfltr/authorization.dart';
import 'package:trackontraktfltr/models/history_item.dart';
import 'package:trackontraktfltr/routes.dart';
import 'package:trackontraktfltr/trakt_api.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _traktApi = TraktApi();
  final _authorization = Authorization();
  DateFormat _watchedAtFormat = new DateFormat.yMd().add_Hm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TrackOnTrakt history"),
        ),
        body: FutureBuilder<List<HistoryItem>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildListView(snapshot);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("${snapshot.error}"));
            }

            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  ListView _buildListView(AsyncSnapshot<List<HistoryItem>> snapshot) {
    var theme = Theme.of(context);

    return ListView.builder(
        itemCount: snapshot.data.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          var item = snapshot?.data[index];
          return InkWell(
              onTap: () {
                _onItemTap(index, item);
              },
              child: Ink(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(item.icon)),
                        Flexible(
                            child: Text(
                          item.title ?? "title n/a",
                          style: theme.textTheme.title,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                item.subtitle ?? "",
                                style: theme.textTheme.subhead,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_typeInfoForItem(item),
                                style: theme.textTheme.caption),
                            Text(
                              _watchedAtFormat.format(item.watchedAt),
                              textAlign: TextAlign.right,
                              style: theme.textTheme.caption,
                            )
                          ],
                        ))
                  ])));
        });
  }

  Future<List<HistoryItem>> _loadData() async {
    final oauthClient = await _authorization.getOauthClient();
    return _traktApi.myHistory(
        oauthClient.credentials.accessToken, _authorization.identifier);
  }

  String _typeInfoForItem(HistoryItem item) {
    return "${item.typeInfo} (${item.year})";
  }

  void _onItemTap(int index, HistoryItem item) {
    Navigator.of(context).pushNamed(Routes.detail(item.id));
  }
}
