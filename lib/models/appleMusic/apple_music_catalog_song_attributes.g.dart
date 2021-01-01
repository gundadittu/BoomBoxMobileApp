// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_music_catalog_song_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleMusicCatalogSongAttributes _$AppleMusicCatalogSongAttributesFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['name', 'artistName', 'isrc', 'artwork'],
      disallowNullValues: const ['name', 'artistName', 'isrc', 'artwork']);
  return AppleMusicCatalogSongAttributes(
    json['url'] as String,
    json['artwork'] == null
        ? null
        : AppleMusicArtwork.fromJson(json['artwork'] as Map<String, dynamic>),
    json['name'] as String,
    json['playParams'] == null
        ? null
        : AppleMusicPlayParams.fromJson(
            json['playParams'] as Map<String, dynamic>),
    json['contentRating'] as String,
    json['isrc'] as String,
    json['releaseDate'] as String,
    (json['genreNames'] as List)?.map((e) => e as String)?.toList(),
    json['artistName'] as String,
    json['durationInMillis'] as int,
    (json['previews'] as List)
        ?.map((e) => e == null
            ? null
            : AppleMusicCatalogSongPreview.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongAttributesToJson(
    AppleMusicCatalogSongAttributes instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('artistName', instance.artistName);
  writeNotNull('isrc', instance.isrc);
  writeNotNull('artwork', instance.artwork);
  val['durationInMillis'] = instance.durationInMillis;
  val['playParams'] = instance.playParams;
  val['contentRating'] = instance.contentRating;
  val['genreNames'] = instance.genreNames;
  val['url'] = instance.url;
  val['releaseDate'] = instance.releaseDate;
  val['previews'] = instance.previews;
  return val;
}
