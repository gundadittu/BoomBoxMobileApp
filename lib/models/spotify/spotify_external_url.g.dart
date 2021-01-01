// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_external_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyExternalUrl _$SpotifyExternalUrlFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['spotify']);
  return SpotifyExternalUrl(
    json['spotify'] as String,
  );
}

Map<String, dynamic> _$SpotifyExternalUrlToJson(SpotifyExternalUrl instance) =>
    <String, dynamic>{
      'spotify': instance.spotify,
    };
