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

AppleMusicCatalogSongAttributes _$AppleMusicCatalogSongAttributesFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'name',
    'artistName',
    'isrc',
    'durationInMillis',
    'playParams',
    'artwork'
  ], disallowNullValues: const [
    'name',
    'artistName',
    'isrc',
    'durationInMillis',
    'playParams',
    'artwork'
  ]);
  return AppleMusicCatalogSongAttributes(
    json['name'] as String,
    json['artistName'] as String,
    json['isrc'] as String,
    json['durationInMillis'] as int,
    (json['genreNames'] as List)?.map((e) => e as String)?.toList(),
    json['releaseDate'] as String,
    json['url'] as String,
    json['contentRating'] as String,
    json['playParams'] == null
        ? null
        : AppleMusicCatalogSongPlayParams.fromJson(
            json['playParams'] as Map<String, dynamic>),
    json['artwork'] == null
        ? null
        : AppleMusicCatalogSongAttributesArtwork.fromJson(
            json['artwork'] as Map<String, dynamic>),
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
  writeNotNull('durationInMillis', instance.durationInMillis);
  writeNotNull('playParams', instance.playParams);
  writeNotNull('artwork', instance.artwork);
  val['contentRating'] = instance.contentRating;
  val['genreNames'] = instance.genreNames;
  val['url'] = instance.url;
  val['releaseDate'] = instance.releaseDate;
  return val;
}

AppleMusicCatalogSongPlayParams _$AppleMusicCatalogSongPlayParamsFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['id'], disallowNullValues: const ['id']);
  return AppleMusicCatalogSongPlayParams(
    json['id'] as String,
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongPlayParamsToJson(
    AppleMusicCatalogSongPlayParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  return val;
}

AppleMusicCatalogSongAttributesArtwork
    _$AppleMusicCatalogSongAttributesArtworkFromJson(
        Map<String, dynamic> json) {
  return AppleMusicCatalogSongAttributesArtwork(
    json['url'] as String,
    json['bgColor'] as String,
    json['width'] as int,
    json['height'] as int,
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongAttributesArtworkToJson(
        AppleMusicCatalogSongAttributesArtwork instance) =>
    <String, dynamic>{
      'url': instance.url,
      'bgColor': instance.bgColor,
      'width': instance.width,
      'height': instance.height,
    };

AppleMusicCatalogSongPreview _$AppleMusicCatalogSongPreviewFromJson(
    Map<String, dynamic> json) {
  return AppleMusicCatalogSongPreview(
    json['url'] as String,
  );
}

Map<String, dynamic> _$AppleMusicCatalogSongPreviewToJson(
        AppleMusicCatalogSongPreview instance) =>
    <String, dynamic>{
      'url': instance.url,
    };
