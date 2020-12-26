// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_auth_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreamingAccountStoreItem _$UserStreamingAccountStoreItemFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['userUid', 'accountType'],
      disallowNullValues: const ['userUid', 'accountType']);
  return UserStreamingAccountStoreItem(
    json['userUid'] as String,
    _$enumDecodeNullable(
        _$UserStreamingAccountStoreItemAccountTypeEnumMap, json['accountType']),
    json['appleMusicAccessToken'] as String,
  );
}

Map<String, dynamic> _$UserStreamingAccountStoreItemToJson(
    UserStreamingAccountStoreItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userUid', instance.userUid);
  writeNotNull('accountType',
      _$UserStreamingAccountStoreItemAccountTypeEnumMap[instance.accountType]);
  val['appleMusicAccessToken'] = instance.appleMusicAccessToken;
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UserStreamingAccountStoreItemAccountTypeEnumMap = {
  UserStreamingAccountStoreItemAccountType.appleMusic: 'appleMusic',
  UserStreamingAccountStoreItemAccountType.spotify: 'spotify',
};
