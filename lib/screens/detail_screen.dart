import 'package:flutter/material.dart';
import 'package:trackontraktfltr/authorization.dart';
import 'package:trackontraktfltr/trakt_api.dart';

class DetailScreen extends StatefulWidget {
  final int _id;
  DetailScreen(this._id, {Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(_id);
}

class _DetailScreenState extends State<DetailScreen> {
  final _traktApi = TraktApi();
  final _authorization = Authorization();
  final int _id;

  _DetailScreenState(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail $_id"),
        ),
        body: Row());
  }
}
