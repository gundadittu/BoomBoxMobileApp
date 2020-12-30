import 'package:json_annotation/json_annotation.dart';

part 'spotify_image.g.dart';

@JsonSerializable()
class SpotifyImage {
  SpotifyImage(
   this.url, 
   this.height, 
   this.width,
  );

  @JsonKey(required: true, name: "url", disallowNullValue: true)
  final String url;

  @JsonKey(required: false, name: "height", disallowNullValue: false)
  final int height;

  @JsonKey(required: false, name: "width", disallowNullValue: false)
  final int width;

  factory SpotifyImage.fromJson(Map<String, dynamic> json) =>
      _$SpotifyImageFromJson(json);

  Map<String, dynamic> toJson() => _$SpotifyImageToJson(this);
}
