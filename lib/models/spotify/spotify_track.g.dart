// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyTrack _$SpotifyTrackFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'id',
    'album',
    'duration_ms',
    'name',
    'uri',
    'external_ids',
    'artists',
    'is_local',
    'href'
  ], disallowNullValues: const [
    'id',
    'album',
    'duration_ms',
    'name',
    'uri',
    'external_ids',
    'artists',
    'href'
  ]);
  return SpotifyTrack(
    json['id'] as String,
    json['name'] as String,
    json['duration_ms'] as int,
    json['explicit'] as bool,
    json['preview_url'] as String,
    json['uri'] as String,
    json['is_local'] as bool,
    json['external_ids'] == null
        ? null
        : SpotifyExternalId.fromJson(
            json['external_ids'] as Map<String, dynamic>),
    json['external_urls'] == null
        ? null
        : SpotifyExternalUrl.fromJson(
            json['external_urls'] as Map<String, dynamic>),
    json['href'] as String,
    (json['artists'] as List)
        ?.map((e) => e == null
            ? null
            : SpotifyArtist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['album'] == null
        ? null
        : SpotifyAlbum.fromJson(json['album'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SpotifyTrackToJson(SpotifyTrack instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('album', instance.album);
  writeNotNull('duration_ms', instance.durationMs);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  writeNotNull('external_ids', instance.externalIds);
  writeNotNull('artists', instance.artists);
  val['is_local'] = instance.isLocal;
  writeNotNull('href', instance.href);
  val['preview_url'] = instance.previewUrl;
  val['explicit'] = instance.explicit;
  val['external_urls'] = instance.externalUrls;
  return val;
}
