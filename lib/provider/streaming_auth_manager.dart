import 'dart:convert';

import 'package:BoomBoxApp/error_manager.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:provider/provider.dart';
import '../streaming/apple_music_auth_manager.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../firebase_manager.dart';
// https://flutter.dev/docs/development/data-and-backend/json
part 'streaming_auth_manager.g.dart';

enum StreamingAuthErrorType {
  unknown,
  incompatibleAccount,
  subscriptionRequired,
  incompatibleDevicePlatform,
  deniedByUser
}

class StreamingAuthError implements Exception {
  final StreamingAuthErrorType type;
  StreamingAuthError(this.type);
}

class StreamingAuthManager with ChangeNotifier {
  String userUid;

  bool canHandlePlayback = false;

  UserStreamingAccountStoreItem streamingAccount;

  StreamingAuthManager(this.userUid);

  Future<void> initializeExistingAuthorizations() async {
    if (userUid == null) {
      // TODO: should i throw an error here? user is not signed in and app is still trying to initialize? prolly not
      ErrorManager.addContext(
          "Returned out of initializeExistingAuthorizations due to null userUid",
          userUid);
      return;
    }
    try {
      final existingStreamingAccount =
          await fetchExistingStreamingAccountItem();
      ErrorManager.addContext(
          "Fetched Current User Streaming Account Store Item",
          existingStreamingAccount);

      // No existing authorizations available
      if (existingStreamingAccount == null) {
        return;
      }

      final accountType = existingStreamingAccount.accountType;
      switch (accountType) {
        case UserStreamingAccountStoreItemAccountType.appleMusic:
          authorizeAppleMusic();
          break;
        case UserStreamingAccountStoreItemAccountType.spotify:
          // TODO
          break;
      }
    } on Exception catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      // User should not see this error as this was an automatic attempt to retrieve existing credentials
    }
  }

  Future<void> authorizeAppleMusic() async {
    final appleMusicAuthManager = AppleMusicAuthManager();
    await appleMusicAuthManager.authorize();
  
    final accessToken = appleMusicAuthManager.userToken;
    canHandlePlayback = appleMusicAuthManager.hasPlaybackCapability;

    final data = {
      'accountType': "appleMusic",
      'appleMusicAccessToken': accessToken,
    };

    streamingAccount = await _setStreamingAccountForUser(data);
    ErrorManager.addContext(
        "Set StreamingAuthManager.streamingaccount value", streamingAccount);

    notifyListeners();
  }

  // Fetches existing User Streaming Account from DB
  Future<UserStreamingAccountStoreItem>
      fetchExistingStreamingAccountItem() async {
    // TODO: save function names in constants file
    HttpsCallable callable = FirebaseManager.functions
        .httpsCallable("fetchExistingStreamingAccountItem");
    final HttpsCallableResult response = await callable.call();
    final data = response.data;

    // No existing authorizations found
    if (data == null) {
      return null;
    }

    try {
      final decodedJson = json.decode(data);
      final item = UserStreamingAccountStoreItem.fromJson(decodedJson);
      return item;
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      return null;
    }
  }

  // Stores new/updated User Streaming Account in DB
  Future<UserStreamingAccountStoreItem> _setStreamingAccountForUser(
      Map<String, dynamic> data) async {
    // TODO: save function names in constants file
    ErrorManager.addContext(
        "Sent setUserStreamingAccount() http request", data);
    HttpsCallable callable =
        FirebaseManager.functions.httpsCallable("setUserStreamingAccount");
    final response = await callable.call(data);
    final streamingAccountData = response.data;
    try {
      final decodedJson = json.decode(streamingAccountData);
      final item = UserStreamingAccountStoreItem.fromJson(decodedJson);
      return item;
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      return null;
    }
  }
}

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
      this.userUid, this.accountType, this.appleMusicAccessToken);

  @JsonKey(required: true, name: "userUid", disallowNullValue: true)
  final String userUid;

  @JsonKey(required: true, name: "accountType", disallowNullValue: true)
  final UserStreamingAccountStoreItemAccountType accountType;

  @JsonKey(name: "appleMusicAccessToken")
  final String appleMusicAccessToken;

  // @JsonKey(name: "spotifyAccessToken")
  //final String spotifyAccessToken;

  factory UserStreamingAccountStoreItem.fromJson(Map<String, dynamic> json) =>
      _$UserStreamingAccountStoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$UserStreamingAccountStoreItemToJson(this);
}
