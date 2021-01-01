import 'package:json_annotation/json_annotation.dart';
part 'user_streaming_library_store_item.g.dart';

@JsonSerializable()
class UserStreamingLibraryStoreItem {
  UserStreamingLibraryStoreItem(this.userUid, this.librarySongsIsrcCodes);

  @JsonKey(required: true, name: "userUid", disallowNullValue: true)
  final String userUid;

  @JsonKey(
      required: false, name: "librarySongsIsrcCodes", disallowNullValue: false)
  final List<String> librarySongsIsrcCodes;

  factory UserStreamingLibraryStoreItem.fromJson(Map<String, dynamic> json) =>
      _$UserStreamingLibraryStoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreamingLibraryStoreItemToJson(this);
}
