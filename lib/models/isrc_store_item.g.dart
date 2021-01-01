// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isrc_store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsrcStoreItem _$IsrcStoreItemFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'isrcId',
    'playEnabledForSpotify',
    'playEnabledForAppleMusic',
    'mediaType'
  ], disallowNullValues: const [
    'isrcId',
    'playEnabledForSpotify',
    'playEnabledForAppleMusic',
    'mediaType'
  ]);
  return IsrcStoreItem(
    isrcId: json['isrcId'] as String,
    playEnabledForSpotify: json['playEnabledForSpotify'] as bool,
    playEnabledForAppleMusic: json['playEnabledForAppleMusic'] as bool,
    availableInAppleMusicCatalog: json['availableInAppleMusicCatalog'] as bool,
    appleMusicCatalogId: json['appleMusicCatalogId'] as String,
    appleMusicCatalogSong: json['appleMusicCatalogSong'] == null
        ? null
        : AppleMusicCatalogSong.fromJson(
            json['appleMusicCatalogSong'] as Map<String, dynamic>),
    availableInSpotifyCatalog: json['availableInSpotifyCatalog'] as bool,
    spotifyId: json['spotifyId'] as String,
    mediaType: _$enumDecodeNullable(
        _$IsrcStoreItemMediaTypeEnumMap, json['mediaType']),
    spotifyTrack: json['spotifyTrack'] == null
        ? null
        : SpotifyTrack.fromJson(json['spotifyTrack'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IsrcStoreItemToJson(IsrcStoreItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isrcId', instance.isrcId);
  writeNotNull('playEnabledForSpotify', instance.playEnabledForSpotify);
  writeNotNull('playEnabledForAppleMusic', instance.playEnabledForAppleMusic);
  writeNotNull(
      'mediaType', _$IsrcStoreItemMediaTypeEnumMap[instance.mediaType]);
  val['availableInAppleMusicCatalog'] = instance.availableInAppleMusicCatalog;
  val['appleMusicCatalogId'] = instance.appleMusicCatalogId;
  val['appleMusicCatalogSong'] = instance.appleMusicCatalogSong;
  val['availableInSpotifyCatalog'] = instance.availableInSpotifyCatalog;
  val['spotifyId'] = instance.spotifyId;
  val['spotifyTrack'] = instance.spotifyTrack;
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$IsrcStoreItemMediaTypeEnumMap = {
  IsrcStoreItemMediaType.song: 'song',
  IsrcStoreItemMediaType.album: 'album',
};
