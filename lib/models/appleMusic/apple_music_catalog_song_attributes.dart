import 'package:json_annotation/json_annotation.dart';

import 'apple_music_play_params.dart';
import 'apple_music_catalog_song_preview.dart';
import 'apple_music_artwork.dart';

part 'apple_music_catalog_song_attributes.g.dart';

@JsonSerializable()
class AppleMusicCatalogSongAttributes {
  AppleMusicCatalogSongAttributes(
    this.url,
    this.artwork,
    this.name,
    this.playParams,
    this.contentRating,
    this.isrc,
    this.releaseDate,
    this.genreNames,
    this.artistName,
    this.durationInMillis,
    this.previews,
  );

  @JsonKey(required: true, name: "name", disallowNullValue: true)
  final String name;

  @JsonKey(required: true, name: "artistName", disallowNullValue: true)
  final String artistName;

  @JsonKey(required: true, name: "isrc", disallowNullValue: true)
  final String isrc;

  @JsonKey(required: true, name: "artwork", disallowNullValue: true)
  final AppleMusicArtwork artwork;

  @JsonKey(required: false, name: "durationInMillis", disallowNullValue: false)
  final int durationInMillis;

  @JsonKey(required: false, name: "playParams", disallowNullValue: false)
  final AppleMusicPlayParams playParams;

  @JsonKey(required: false, name: "contentRating", disallowNullValue: false)
  final String contentRating;

  @JsonKey(required: false, name: "genreNames", disallowNullValue: false)
  final List<String> genreNames;

  @JsonKey(required: false, name: "url", disallowNullValue: false)
  final String url;

  @JsonKey(required: false, name: "releaseDate", disallowNullValue: false)
  final String releaseDate;

  @JsonKey(required: false, name: "previews", disallowNullValue: false)
  final List<AppleMusicCatalogSongPreview> previews;

  factory AppleMusicCatalogSongAttributes.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AppleMusicCatalogSongAttributesToJson(this);
}
