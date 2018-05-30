import 'package:json_annotation/json_annotation.dart';
import 'package:trackontraktfltr/models/media.dart';

part 'history_item.g.dart';

enum HistoryAction { scrobble, checkin, watch }

@JsonSerializable()
class HistoryItem extends MediaItem with _$HistoryItemSerializerMixin {
  final int id;
  @JsonKey(name: 'watched_at')
  final DateTime watchedAt;
  final HistoryAction action;

  HistoryItem({this.id, this.watchedAt, this.action});


  factory HistoryItem.fromJson(Map<String, dynamic> json) => _$HistoryItemFromJson(json);


}


