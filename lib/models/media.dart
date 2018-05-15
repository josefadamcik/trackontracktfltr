import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

enum MediaType { movie, episode, show }

@JsonSerializable()
class Movie extends Object with _$MovieSerializerMixin {
  final String title;
  final int year;
  //val ids: MediaIds
  Movie(this.title, this.year);
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
@JsonSerializable()
class Episode extends Object with _$EpisodeSerializerMixin {
  final int season;
  final int number;
  final String title;
//  final ids: MediaIds,
//  final overview: String? = null,
//  final rating: Float? = 0.0f,
//  final votes: Int? = 0,
//  final first_aired: LocalDate? = null,
//  final runtime: Int? = 0
  Episode(this.season, this.number, this.title);
  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
}
@JsonSerializable()
class Show extends Object with _$ShowSerializerMixin {
  final String title;
  final int year;
  //val ids: MediaIds
  Show(this.title, this.year);
  factory Show.fromJson(Map<String, dynamic> json) => _$ShowFromJson(json);
}


abstract class MediaItem {
  MediaType type;
  Movie movie;
  Episode episode;
  Show show;

  String get title {
    switch(type) {
      case MediaType.episode:
          return show?.title;
      case MediaType.show:
        return show?.title;
      case MediaType.movie:
        return movie?.title;
    }
    return null;
  }
}


