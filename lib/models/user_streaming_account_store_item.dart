
import 'package:json_annotation/json_annotation.dart';
part 'user_streaming_account_store_item.g.dart';

// JSON Serializable library: https://flutter.dev/docs/development/data-and-backend/json
// Helpful Tutorial: https://medium.com/codechai/validating-json-in-flutter-6f07ec9344f8
// @JsonSerializable()
// class UserStreamingAccountStoreItemLibrary {
//   UserStreamingAccountStoreItemLibrary(this.songs);

//   @JsonKey(required: true, name: "songs", disallowNullValue: true)
//   List<String> songs;

//   factory UserStreamingAccountStoreItemLibrary.fromJson(
//           Map<String, dynamic> json) =>
//       _$UserStreamingAccountStoreItemLibraryFromJson(json);
// }

enum UserStreamingAccountStoreItemAccountType {
  @JsonValue("appleMusic")
  appleMusic,
  @JsonValue("spotify")
  spotify
}

@JsonSerializable()
class UserStreamingAccountStoreItem {
  UserStreamingAccountStoreItem(
      this.userUid, this.accountType, this.appleMusicAccessToken, this.spotifyAccessToken);

  @JsonKey(required: true, name: "userUid", disallowNullValue: true)
  final String userUid;

  @JsonKey(required: true, name: "accountType", disallowNullValue: true)
  final UserStreamingAccountStoreItemAccountType accountType;

  @JsonKey(name: "appleMusicAccessToken")
  final String appleMusicAccessToken;

  @JsonKey(name: "spotifyAccessToken")
  final String spotifyAccessToken;

  factory UserStreamingAccountStoreItem.fromJson(Map<String, dynamic> json) =>
      _$UserStreamingAccountStoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreamingAccountStoreItemToJson(this);
}