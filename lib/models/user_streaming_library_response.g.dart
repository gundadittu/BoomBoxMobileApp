// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streaming_library_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreamingLibraryResponse _$UserStreamingLibraryResponseFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['streamingLibraryStoreItem', 'librarySongs'],
      disallowNullValues: const ['streamingLibraryStoreItem', 'librarySongs']);
  return UserStreamingLibraryResponse(
    json['streamingLibraryStoreItem'] == null
        ? null
        : UserStreamingLibraryStoreItem.fromJson(
            json['streamingLibraryStoreItem'] as Map<String, dynamic>),
    (json['librarySongs'] as List)
        ?.map((e) => e == null
            ? null
            : IsrcStoreItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserStreamingLibraryResponseToJson(
    UserStreamingLibraryResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('streamingLibraryStoreItem', instance.streamingLibraryStoreItem);
  writeNotNull('librarySongs', instance.librarySongs);
  return val;
}
