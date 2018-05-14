import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TrackOnTrakt"),),
      body: ListView(),
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
