
import 'package:json_annotation/json_annotation.dart';

part 'apple_music_catalog_song_preview.g.dart';

@JsonSerializable()
class AppleMusicCatalogSongPreview {
  AppleMusicCatalogSongPreview(this.url);

  @JsonKey(required: true, name: "url", disallowNullValue: true)
  final String url;

  factory AppleMusicCatalogSongPreview.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$AppleMusicCatalogSongPreviewToJson(this);
}