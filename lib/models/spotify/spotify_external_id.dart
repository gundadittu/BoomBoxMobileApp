import 'package:json_annotation/json_annotation.dart';

part 'spotify_external_id.g.dart';

@JsonSerializable()
class SpotifyExternalId {
  SpotifyExternalId(this.isrc);

  @JsonKey(
    required: true,
    name: "isrc",
    disallowNullValue: true,
  )
  final String isrc;

  factory SpotifyExternalId.fromJson(Map<String, dynamic> json) =>
      _$SpotifyExternalIdFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyExternalIdToJson(this);
}
