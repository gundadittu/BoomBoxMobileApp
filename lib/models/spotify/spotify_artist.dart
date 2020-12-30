import 'package:json_annotation/json_annotation.dart';
import 'spotify_image.dart';
import 'spotify_external_url.dart';

part 'spotify_artist.g.dart';

@JsonSerializable()
class SpotifyArtist {
  SpotifyArtist(
    this.href,
    this.id,
    this.name,
    this.uri,
    this.externalUrls,
    this.images,
  );

  @JsonKey(required: true, name: "href", disallowNullValue: true)
  final String href;

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  @JsonKey(required: true, name: "name", disallowNullValue: true)
  final String name;

  @JsonKey(required: true, name: "uri", disallowNullValue: true)
  final String uri;

  @JsonKey(required: false, name: "images", disallowNullValue: false)
  final List<SpotifyImage> images;

  @JsonKey(required: false, name: "external_urls", disallowNullValue: false)
  final SpotifyExternalUrl externalUrls;

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifyArtistFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyArtistToJson(this);
}
