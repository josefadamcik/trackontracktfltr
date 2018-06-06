import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackontraktfltr/history/history_item.dart';
import 'package:trackontraktfltr/resources/routes.dart';
import 'package:trackontraktfltr/resources/strings.dart';
import 'package:trackontraktfltr/resources/style.dart';

class HistoryScreen extends StatefulWidget {
  final _traktApi;
  final _authorization;
  HistoryScreen(this._traktApi, this._authorization, {Key key})
      : super(key: key);

  @override
  _HistoryScreenState createState() =>
      _HistoryScreenState(_traktApi, _authorization);
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _traktApi;
  final _authorization;

  _HistoryScreenState(this._traktApi, this._authorization);

  @override
  Widget build(BuildContext context) {
    final screenTitleTheme = Theme
        .of(context)
        .textTheme
        .title
        .copyWith(fontFamily: AppStyle.fontRobotoSlab, color: Colors.white);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.appName,
            style: screenTitleTheme,
          ),
          actions: <Widget>[
            Builder(
              // Builder must be used so  Scaffold.of(context) can find a scaffold for Snackbar
              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print("search tap");
                      final snack = SnackBar(
                        content: Text("Search tap"),
                      );
                      Scaffold.of(context).showSnackBar(snack);
                    });
              },
            )
          ],
        ),
        body: FutureBuilder<List<HistoryItem>>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _HistoryList(snapshot.data);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("${snapshot.error}"));
            }

            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<List<HistoryItem>> _loadData() async {
    return _traktApi.myHistory(
        await _authorization.getAccessToken(), _authorization.identifier);
  }
}

class _HistoryList extends StatelessWidget {
  final List<HistoryItem> _items;
  final DateFormat _watchedAtFormat = new DateFormat.yMd().add_Hm();

  _HistoryList(this._items, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
        itemCount: _items.length,
        padding: EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          var item = _items[index];
          return InkWell(
              onTap: () {
                _onItemTap(context, index, item);
              },
              child: Ink(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child:
                                Icon(item.icon, color: AppStyle.accentColor)),
                        Flexible(
                            child: Text(
                          item.title ?? Strings.titleNa,
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
                                style: theme.textTheme.subhead.copyWith(
                                    color: AppStyle.textColorSecondary),
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

  void _onItemTap(BuildContext context, int index, HistoryItem item) {
    Navigator.of(context).push(Routes.detail(item));
  }

  String _typeInfoForItem(HistoryItem item) {
    return "${item.typeInfo} (${item.year})";
  }
}
