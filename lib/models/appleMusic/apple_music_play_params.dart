import 'package:json_annotation/json_annotation.dart';

part 'apple_music_play_params.g.dart';

@JsonSerializable()
class AppleMusicPlayParams {
  AppleMusicPlayParams(this.id);

  @JsonKey(required: true, name: "id", disallowNullValue: true)
  final String id;

  factory AppleMusicPlayParams.fromJson(Map<String, dynamic> json) =>
      _$AppleMusicPlayParamsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AppleMusicPlayParamsToJson(this);
}