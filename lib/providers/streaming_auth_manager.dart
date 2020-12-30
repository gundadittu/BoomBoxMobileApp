import 'dart:convert';
import 'package:BoomBoxApp/error_manager.dart';
import 'package:BoomBoxApp/streaming/spotify_auth_manager.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../streaming/apple_music_auth_manager.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../firebase_manager.dart';
// https://flutter.dev/docs/development/data-and-backend/json
import '../models/user_streaming_account_store_item.dart';

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

  VoidCallback authSuccessHandler;
  Function(StreamingAuthError) authFailureHandler;

  static final StreamingAuthManager _singleton =
      new StreamingAuthManager._internal();

  StreamingAuthManager._internal() {}
  
  factory StreamingAuthManager() {
    StreamingAuthManager._singleton.notifyListeners();
    return _singleton;
  }

  void update(String userUid) {
    userUid = userUid;
    if (userUid == null) {
      // TODO: Clear all values in class
    } else {
      _initializeExistingAuthorizations();
    }
  }

  Future<void> _initializeExistingAuthorizations() async {
    if (userUid == null) {
      // TODO: should i throw an error here? user is not signed in and app is still trying to initialize? prolly not
      ErrorManager.addContext(
          "Returned out of initializeExistingAuthorizations due to null userUid",
          userUid);
      return;
    }
    authSuccessHandler = () => print("success");
    authFailureHandler = (StreamingAuthError e) => print(e);

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
          authorizeAppleMusic(authSuccessHandler, authFailureHandler);
          break;
        case UserStreamingAccountStoreItemAccountType.spotify:
          authorizeSpotify(authSuccessHandler, authFailureHandler);
          break;
      }
    } on Exception catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      // User should not see this error as this was an automatic attempt to retrieve existing credentials
    }
  }

  Future<void> authorizeSpotify(VoidCallback successHandler,
      Function(StreamingAuthError) failureHandler) async {
    authSuccessHandler = successHandler;
    authFailureHandler = failureHandler;

    final spotifyAuthManager = SpotifyAuthManager();
    await spotifyAuthManager.authorize(
        _onSpotifyAuthSuccess, _onSpotifyAuthFailure);
  }

  void _onSpotifyAuthSuccess(String accessToken) async {
    final data = {
      'accountType': "spotify",
      'spotifyAccessToken': accessToken,
    };

    streamingAccount = await _setStreamingAccountForUser(data);
    ErrorManager.addContext(
        "Set StreamingAuthManager.streamingaccount value", streamingAccount);

    authSuccessHandler();

    notifyListeners();
  }

  void _onSpotifyAuthFailure(StreamingAuthError error) {
    authFailureHandler(error);
  }

  Future<void> authorizeAppleMusic(VoidCallback successHandler,
      Function(StreamingAuthError) failureHandler) async {
    authSuccessHandler = successHandler;
    authFailureHandler = failureHandler;

    final appleMusicAuthManager = AppleMusicAuthManager();
    await appleMusicAuthManager.authorize(
        _onAppleMusicAuthSuccess, _onAppleMusicAuthFailure);
  }

  void _onAppleMusicAuthSuccess(String accessToken) async {
    final data = {
      'accountType': "appleMusic",
      'appleMusicAccessToken': accessToken,
    };

    streamingAccount = await _setStreamingAccountForUser(data);
    ErrorManager.addContext(
        "Set StreamingAuthManager.streamingaccount value", streamingAccount);

    authSuccessHandler();

    notifyListeners();
  }

  void _onAppleMusicAuthFailure(StreamingAuthError e) async {
    authFailureHandler(e);
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
