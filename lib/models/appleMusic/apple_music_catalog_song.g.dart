// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_music_catalog_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleMusicCatalogSong _$AppleMusicCatalogSongFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['attributes', 'href', 'id'],
      disallowNullValues: const ['attributes', 'href', 'id']);
  return AppleMusicCatalogSong(
    json['id'] as String,
    json['href'] as String,
    json['attributes'] == null
        ? null
        : AppleMusicCatalogSongAttributes.fromJson(
            json['attributes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongToJson(
    AppleMusicCatalogSong instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attributes', instance.attributes);
  writeNotNull('href', instance.href);
  writeNotNull('id', instance.id);
  return val;
}
