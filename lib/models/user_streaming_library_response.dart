import 'package:BoomBoxApp/models/isrc_store_item.dart';
import 'package:BoomBoxApp/models/user_streaming_library_store_item.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_streaming_library_response.g.dart';

@JsonSerializable()
class UserStreamingLibraryResponse {
  UserStreamingLibraryResponse(
      this.streamingLibraryStoreItem, this.librarySongs);

  @JsonKey(
    required: true,
    name: "streamingLibraryStoreItem",
    disallowNullValue: true,
  )
  final UserStreamingLibraryStoreItem streamingLibraryStoreItem;

  @JsonKey(
    required: true,
    name: "librarySongs",
    disallowNullValue: true,
  )
  final List<IsrcStoreItem> librarySongs;

  factory UserStreamingLibraryResponse.fromJson(Map<String, dynamic> json) =>
      _$UserStreamingLibraryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreamingLibraryResponseToJson(this);
}

// streamingLibraryStoreItem: UserStreamingLibraryStoreItem,
//   librarySongs: Array<IsrcStoreItem>
