import 'package:json_annotation/json_annotation.dart';

part 'apple_music_artwork.g.dart';

@JsonSerializable()
class AppleMusicArtwork {
  AppleMusicArtwork(
   this.url, 
   this.height, 
   this.width,
   this.bgColor
  );

  @JsonKey(required: true, name: "url", disallowNullValue: true)
  final String url;

  @JsonKey(required: false, name: "height", disallowNullValue: false)
  final int height;

  @JsonKey(required: false, name: "width", disallowNullValue: false)
  final int width;

  @JsonKey(required: false, name: "bgColor", disallowNullValue: false)
  final String bgColor;

  factory AppleMusicArtwork.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$AppleMusicArtworkToJson(this);
}
