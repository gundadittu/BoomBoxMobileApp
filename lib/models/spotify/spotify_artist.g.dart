// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyArtist _$SpotifyArtistFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['href', 'id', 'name', 'uri'],
      disallowNullValues: const ['href', 'id', 'name', 'uri']);
  return SpotifyArtist(
    json['href'] as String,
    json['id'] as String,
    json['name'] as String,
    json['uri'] as String,
    json['external_urls'] == null
        ? null
        : SpotifyExternalUrl.fromJson(
            json['external_urls'] as Map<String, dynamic>),
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : SpotifyImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SpotifyArtistToJson(SpotifyArtist instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('href', instance.href);
  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('uri', instance.uri);
  val['images'] = instance.images;
  val['external_urls'] = instance.externalUrls;
  return val;
}
