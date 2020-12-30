import 'package:json_annotation/json_annotation.dart';

import './apple_music_catalog_song.dart';
import 'spotify/spotify_track.dart';

part 'isrc_store_item.g.dart';

enum IsrcStoreItemMediaType {
  @JsonValue("song")
  song,
  @JsonValue("album")
  album
}

@JsonSerializable()
class IsrcStoreItem {
  IsrcStoreItem(
      {this.isrcId,
      this.playEnabledForSpotify,
      this.playEnabledForAppleMusic,
      this.availableInAppleMusicCatalog,
      this.appleMusicCatalogId,
      this.appleMusicCatalogSong,
      this.availableInSpotifyCatalog,
      this.spotifyId,
      this.mediaType,
      this.spotifyTrack});

  @JsonKey(
    required: true,
    name: "isrcId",
    disallowNullValue: true,
  )
  final String isrcId;

  @JsonKey(
    required: true,
    name: "playEnabledForSpotify",
    disallowNullValue: true,
  )
  final bool playEnabledForSpotify;

  @JsonKey(
    required: true,
    name: "playEnabledForAppleMusic",
    disallowNullValue: true,
  )
  final bool playEnabledForAppleMusic;

  @JsonKey(
    required: true,
    name: "mediaType",
    disallowNullValue: true,
  )
  final IsrcStoreItemMediaType mediaType;

  @JsonKey(
    name: "availableInAppleMusicCatalog",
    disallowNullValue: false,
  )
  final bool availableInAppleMusicCatalog;

  @JsonKey(
    name: "appleMusicCatalogId",
    disallowNullValue: false,
  )
  final String appleMusicCatalogId;

  @JsonKey(
    name: "appleMusicCatalogSong",
    disallowNullValue: true,
  )
  final AppleMusicCatalogSong appleMusicCatalogSong;

  @JsonKey(
    name: "availableInSpotifyCatalog",
    disallowNullValue: false,
  )
  final bool availableInSpotifyCatalog;

  @JsonKey(
    name: "spotifyId",
    disallowNullValue: false,
  )
  final String spotifyId;

  @JsonKey(
    name: "spotifyTrack",
    disallowNullValue: false,
  )
  final SpotifyTrack spotifyTrack;

  factory IsrcStoreItem.fromJson(Map<String, dynamic> json) =>
      _$IsrcStoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$IsrcStoreItemToJson(this);
}
