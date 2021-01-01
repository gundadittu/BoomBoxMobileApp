// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_music_catalog_song_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleMusicCatalogSongPreview _$AppleMusicCatalogSongPreviewFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['url'], disallowNullValues: const ['url']);
  return AppleMusicCatalogSongPreview(
    json['url'] as String,
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongPreviewToJson(
    AppleMusicCatalogSongPreview instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  return val;
}
