// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streaming_library_store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreamingLibraryStoreItem _$UserStreamingLibraryStoreItemFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['userUid', 'librarySongs'],
      disallowNullValues: const ['userUid', 'librarySongs']);
  return UserStreamingLibraryStoreItem(
    json['userUid'] as String,
    (json['librarySongs'] as List)
        ?.map((e) => e == null
            ? null
            : IsrcStoreItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserStreamingLibraryStoreItemToJson(
    UserStreamingLibraryStoreItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userUid', instance.userUid);
  writeNotNull('librarySongs', instance.librarySongs);
  return val;
}
