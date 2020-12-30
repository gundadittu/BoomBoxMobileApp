// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_external_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyExternalId _$SpotifyExternalIdFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['isrc'], disallowNullValues: const ['isrc']);
  return SpotifyExternalId(
    json['isrc'] as String,
  );
}

Map<String, dynamic> _$SpotifyExternalIdToJson(SpotifyExternalId instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isrc', instance.isrc);
  return val;
}
