// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyImage _$SpotifyImageFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['url'], disallowNullValues: const ['url']);
  return SpotifyImage(
    json['url'] as String,
    json['height'] as int,
    json['width'] as int,
  );
}

Map<String, dynamic> _$SpotifyImageToJson(SpotifyImage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  val['height'] = instance.height;
  val['width'] = instance.width;
  return val;
}
