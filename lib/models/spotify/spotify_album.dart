import 'package:json_annotation/json_annotation.dart';

import 'spotify_artist.dart';
import 'spotify_external_url.dart';
import 'package:BoomBoxApp/models/spotify/spotify_external_id.dart';
import 'spotify_image.dart';

part 'spotify_album.g.dart';

@JsonSerializable()
class SpotifyAlbum {
  SpotifyAlbum(
    this.images,
    this.artists,
    this.externalUrls,
    this.uri,
    this.href,
    this.externalIds,
    this.name,
    this.id,
  );

  @JsonKey(required: true, name: "href", disallowNullValue: true)
  final String href;

  @JsonKey(required: true, name: "artists", disallowNullValue: true)
  final List<SpotifyArtist> artists;

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  @JsonKey(required: true, name: "name", disallowNullValue: true)
  final String name;

  @JsonKey(required: true, name: "uri", disallowNullValue: true)
  final String uri;

  @JsonKey(required: false, name: "images", disallowNullValue: false)
  final List<SpotifyImage> images;

  @JsonKey(required: false, name: "external_ids", disallowNullValue: false)
  final SpotifyExternalId externalIds;

  @JsonKey(required: false, name: "external_urls", disallowNullValue: false)
  final SpotifyExternalUrl externalUrls;

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) =>
      _$SpotifyAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyAlbumToJson(this);
}
