import 'package:flutter/material.dart';
import 'package:trackontraktfltr/detail/detail_screen.dart';
import 'package:trackontraktfltr/models/media.dart';

class Routes {
  static const String history = "/history";
  static const String login = "/login";
  static const String detailRoot = "/detail/";
  static Route detail(MediaItem mediaItem) => MaterialPageRoute<void>(builder: (BuildContext context) {
    return DetailScreen(mediaItem);
  });
}
