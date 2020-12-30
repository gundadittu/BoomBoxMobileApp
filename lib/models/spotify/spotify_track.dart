import 'spotify_artist.dart';
import 'spotify_external_id.dart';
import 'spotify_external_url.dart';
import 'spotify_album.dart';

import 'package:json_annotation/json_annotation.dart';

part 'spotify_track.g.dart';

@JsonSerializable()
class SpotifyTrack {
  SpotifyTrack(
    this.id,
    this.name,
    this.durationMs,
    this.explicit,
    this.isPlayable,
    this.previewUrl,
    this.uri,
    this.isLocal,
    this.externalIds,
    this.externalUrls,
    this.href,
    this.artists,
    this.album,
  );

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  @JsonKey(required: true, name: "album", disallowNullValue: true)
  final SpotifyAlbum album;

  @JsonKey(required: true, name: "duration_ms", disallowNullValue: true)
  final int durationMs;

  @JsonKey(required: true, name: "is_playable", disallowNullValue: true)
  final bool isPlayable;

  @JsonKey(required: true, name: "name", disallowNullValue: true)
  final String name;

  @JsonKey(required: true, name: "uri", disallowNullValue: true)
  final String uri;

  @JsonKey(required: true, name: "external_ids", disallowNullValue: true)
  final SpotifyExternalId externalIds;

  @JsonKey(required: true, name: "artists", disallowNullValue: true)
  final List<SpotifyArtist> artists;

  @JsonKey(required: true, name: "is_local", disallowNullValue: false)
  final bool isLocal;

  @JsonKey(required: true, name: "href", disallowNullValue: true)
  final String href;

  @JsonKey(required: false, name: "preview_url", disallowNullValue: false)
  final String previewUrl;

  @JsonKey(required: false, name: "explicit", disallowNullValue: false)
  final bool explicit;

  @JsonKey(required: false, name: "external_urls", disallowNullValue: false)
  final SpotifyExternalUrl externalUrls;

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTrackFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyTrackToJson(this);
}
