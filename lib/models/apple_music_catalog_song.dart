import 'package:json_annotation/json_annotation.dart';
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

@JsonSerializable()
class AppleMusicCatalogSongAttributes {
  AppleMusicCatalogSongAttributes(
    this.name,
    this.artistName,
    this.isrc,
    this.durationInMillis,
    this.genreNames,
    this.releaseDate,
    this.url,
    this.contentRating,
    this.playParams,
    this.artwork,
  );
  @JsonKey(required: true, name: "name", disallowNullValue: true)
  final String name;

  @JsonKey(required: true, name: "artistName", disallowNullValue: true)
  final String artistName;

  @JsonKey(required: true, name: "isrc", disallowNullValue: true)
  final String isrc;

  @JsonKey(required: true, name: "durationInMillis", disallowNullValue: true)
  final int durationInMillis;

  @JsonKey(required: true, name: "playParams", disallowNullValue: true)
  final AppleMusicCatalogSongPlayParams playParams;

  @JsonKey(required: true, name: "artwork", disallowNullValue: true)
  final AppleMusicCatalogSongAttributesArtwork artwork;

  @JsonKey(required: false, name: "contentRating", disallowNullValue: false)
  final String contentRating;

  @JsonKey(required: false, name: "genreNames", disallowNullValue: false)
  final List<String> genreNames;

  @JsonKey(required: false, name: "url", disallowNullValue: false)
  final String url;

  @JsonKey(required: false, name: "releaseDate", disallowNullValue: false)
  final String releaseDate;

  factory AppleMusicCatalogSongAttributes.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongAttributesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AppleMusicCatalogSongAttributesToJson(this);
}

@JsonSerializable()
class AppleMusicCatalogSongPlayParams {
  AppleMusicCatalogSongPlayParams(this.id);

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  factory AppleMusicCatalogSongPlayParams.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongPlayParamsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AppleMusicCatalogSongPlayParamsToJson(this);
}

@JsonSerializable()
class AppleMusicCatalogSongAttributesArtwork {
  AppleMusicCatalogSongAttributesArtwork(
    this.url,
    this.bgColor,
    this.width,
    this.height,
  );

  @JsonKey(required: false, name: "url", disallowNullValue: false)
  final String url;

  @JsonKey(required: false, name: "bgColor", disallowNullValue: false)
  final String bgColor;

  @JsonKey(required: false, name: "width", disallowNullValue: false)
  final int width;

  @JsonKey(required: false, name: "height", disallowNullValue: false)
  final int height;

  factory AppleMusicCatalogSongAttributesArtwork.fromJson(
          Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongAttributesArtworkFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AppleMusicCatalogSongAttributesArtworkToJson(this);
}

@JsonSerializable()
class AppleMusicCatalogSongPreview {
  AppleMusicCatalogSongPreview(this.url);

  @JsonKey(required: false, name: "url", disallowNullValue: false)
  final String url;

  factory AppleMusicCatalogSongPreview.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicCatalogSongPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$AppleMusicCatalogSongPreviewToJson(this);
}
