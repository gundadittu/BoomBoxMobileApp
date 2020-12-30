import 'package:BoomBoxApp/models/isrc_store_item.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_streaming_library_store_item.g.dart';

@JsonSerializable()
class UserStreamingLibraryStoreItem {
  UserStreamingLibraryStoreItem(this.userUid, this.librarySongs);

  @JsonKey(required: true, name: "userUid", disallowNullValue: true)
  final String userUid;
  @JsonKey(required: true, name: "librarySongs", disallowNullValue: true)
  final List<IsrcStoreItem> librarySongs;

  factory UserStreamingLibraryStoreItem.fromJson(Map<String, dynamic> json) =>
      _$UserStreamingLibraryStoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreamingLibraryStoreItemToJson(this);
}
