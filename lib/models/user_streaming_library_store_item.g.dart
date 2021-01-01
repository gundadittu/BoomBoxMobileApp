// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streaming_library_store_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreamingLibraryStoreItem _$UserStreamingLibraryStoreItemFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['userUid'], disallowNullValues: const ['userUid']);
  return UserStreamingLibraryStoreItem(
    json['userUid'] as String,
    (json['librarySongsIsrcCodes'] as List)?.map((e) => e as String)?.toList(),
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
  val['librarySongsIsrcCodes'] = instance.librarySongsIsrcCodes;
  return val;
}
