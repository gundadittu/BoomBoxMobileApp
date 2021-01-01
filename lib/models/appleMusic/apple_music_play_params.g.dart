// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_music_play_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleMusicPlayParams _$AppleMusicPlayParamsFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['id'], disallowNullValues: const ['id']);
  return AppleMusicPlayParams(
    json['id'] as String,
  );
}

Map<String, dynamic> _$AppleMusicPlayParamsToJson(
    AppleMusicPlayParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  return val;
}
