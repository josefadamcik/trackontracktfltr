import 'package:flutter/material.dart';
import 'package:trackontraktfltr/login/authorization.dart';
import 'package:trackontraktfltr/models/media.dart';
import 'package:trackontraktfltr/trakt_api.dart';

class DetailScreen extends StatefulWidget {
  final MediaItem _mediaItem;
  DetailScreen(this._mediaItem, {Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(_mediaItem);
}

class _DetailScreenState extends State<DetailScreen> {
  final _traktApi = TraktApi();
  final _authorization = Authorization();
  final MediaItem _mediaItem;

  _DetailScreenState(this._mediaItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail ${_mediaItem.title}"),
        ),
        body: Row());
  }
}
