// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_music_artwork.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleMusicArtwork _$AppleMusicArtworkFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['url'], disallowNullValues: const ['url']);
  return AppleMusicArtwork(
    json['url'] as String,
    json['height'] as int,
    json['width'] as int,
    json['bgColor'] as String,
  );
}

Map<String, dynamic> _$AppleMusicArtworkToJson(AppleMusicArtwork instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  val['height'] = instance.height;
  val['width'] = instance.width;
  val['bgColor'] = instance.bgColor;
  return val;
}
