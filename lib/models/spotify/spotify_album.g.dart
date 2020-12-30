// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyAlbum _$SpotifyAlbumFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['href', 'artists', 'id', 'name', 'uri'],
      disallowNullValues: const ['href', 'artists', 'id', 'name', 'uri']);
  return SpotifyAlbum(
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : SpotifyImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['artists'] as List)
        ?.map((e) => e == null
            ? null
            : SpotifyArtist.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['external_urls'] == null
        ? null
        : SpotifyExternalUrl.fromJson(
            json['external_urls'] as Map<String, dynamic>),
    json['uri'] as String,
    json['href'] as String,
    json['external_ids'] == null
        ? null
        : SpotifyExternalId.fromJson(
            json['external_ids'] as Map<String, dynamic>),
    json['name'] as String,
    json['id'] as String,
  );
}

Map<String, dynamic> _$SpotifyAlbumToJson(SpotifyAlbum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('href', instance.href);
  writeNotNull('artists', instance.artists);
  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  val['images'] = instance.images;
  val['external_ids'] = instance.externalIds;
  val['external_urls'] = instance.externalUrls;
  return val;
}
