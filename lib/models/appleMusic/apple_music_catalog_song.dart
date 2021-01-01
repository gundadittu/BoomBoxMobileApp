import 'package:json_annotation/json_annotation.dart';

import 'apple_music_catalog_song_attributes.dart';

part 'apple_music_catalog_song.g.dart';

@JsonSerializable()
class AppleMusicCatalogSong {
  AppleMusicCatalogSong(this.id, this.href, this.attributes);

  @JsonKey(required: true, name: "attributes", disallowNullValue: true)
  final AppleMusicCatalogSongAttributes attributes;

  @JsonKey(required: true, name: "href", disallowNullValue: true)
  final String href;

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  factory AppleMusicCatalogSong.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongFromJson(json);

  Map<String, dynamic> toJson() => _$AppleMusicCatalogSongToJson(this);
}

// @JsonSerializable()
// class AppleMusicCatalogSongPreview {
//   AppleMusicCatalogSongPreview(this.url);

//   @JsonKey(required: false, name: "url", disallowNullValue: false)
//   final String url;

//   factory AppleMusicCatalogSongPreview.fromJson(Map<String, dynamic> json) =>
//       _$AppleMusicCatalogSongPreviewFromJson(json);

//   Map<String, dynamic> toJson() => _$AppleMusicCatalogSongPreviewToJson(this);
// }
