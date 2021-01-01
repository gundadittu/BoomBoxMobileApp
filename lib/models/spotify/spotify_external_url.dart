import 'package:json_annotation/json_annotation.dart';

part 'spotify_external_url.g.dart';

@JsonSerializable()
class SpotifyExternalUrl {
  SpotifyExternalUrl(this.spotify);

  @JsonKey(required: true, name: "spotify", disallowNullValue: false)
  final String spotify;

  factory SpotifyExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$SpotifyExternalUrlFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyExternalUrlToJson(this);
}
