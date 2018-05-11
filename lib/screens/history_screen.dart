import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => new _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("TrackOnTrakt"),),
      body: new ListView(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async{

  }
}
