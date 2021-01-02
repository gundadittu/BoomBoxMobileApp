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

// class StreamingAuthManager with ChangeNotifier {
//   String _userUid;
//   UserStreamingAccountStoreItem _streamingAccount;
//   VoidCallback authSuccessHandler;
//   Function(StreamingAuthError) authFailureHandler;

//   UserStreamingAccountStoreItem get streamingAccount {
//     return _streamingAccount;
//   }

//   static final StreamingAuthManager _singleton =
//       new StreamingAuthManager._internal();

//   StreamingAuthManager._internal() {}

//   factory StreamingAuthManager() {
//     StreamingAuthManager._singleton.notifyListeners();
//     return _singleton;
//   }

//   // Used by ChangeNotifierProxyProvider to update this model when AuthManager provided has updates.
//   void update(String newUserUid) {
//     print("in StreamingAuthManager.update");
//     if (_userUid == newUserUid) {
//       // Do nothing since userUid is still the same;
//       ErrorManager.addContext(
//           "Returning out of_initializeExistingAuthorizations() - newUserUid is the same as existing userUid.",
//           {newUserUid: newUserUid});
//       return;
//     } else if (newUserUid == null) {
//       // TODO: Clear all values in class
//       ErrorManager.addContext(
//           "Setting new _userUid value and calling _initializeExistingAuthorizations()",
//           {newUserUid: newUserUid});
//       return;
//     } else {
//       ErrorManager.addContext(
//           "Setting new _userUid value and calling _initializeExistingAuthorizations()",
//           {newUserUid: newUserUid});
//       _userUid = newUserUid;
//       _initializeExistingAuthorizations();
//     }
//   }

//   Future<void> _initializeExistingAuthorizations() async {
//     if (_userUid == null) {
//       ErrorManager.addContext(
//           "Returning void since _userUid == null. Should not be happening.",
//           _userUid);
//       return;
//     }
//     authSuccessHandler = () => print("success");
//     authFailureHandler = (StreamingAuthError e) => print(e);

//     try {
//       final existingStreamingAccount =
//           await fetchExistingStreamingAccountItem();
//       ErrorManager.addContext(
//           "Fetched Current User Streaming Account Store Item",
//           existingStreamingAccount);

//       // No existing authorizations available
//       if (existingStreamingAccount == null) {
//         // TODO: log this
//         ErrorManager.addContext(
//             "Returning void since user streaming account store item was null.",
//             {"userUid": _userUid});
//         return;
//       }

//       final accountType = existingStreamingAccount.accountType;
//       switch (accountType) {
//         case UserStreamingAccountStoreItemAccountType.appleMusic:
//           authorizeAppleMusic(authSuccessHandler, authFailureHandler);
//           break;
//         case UserStreamingAccountStoreItemAccountType.spotify:
//           authorizeSpotify(authSuccessHandler, authFailureHandler);
//           break;
//       }
//     } on Exception catch (e, stackTrace) {
//       ErrorManager.reportError(e, stackTrace);
//       // Do not throw error. User should not see this error as this was an automatic attempt to retrieve existing credentials
//     }
//   }

//   // Stores new/updated User Streaming Account in DB
//   Future<UserStreamingAccountStoreItem> _setStreamingAccountForUser(
//       Map<String, dynamic> data) async {
//     // TODO: save function names in constants file
//     ErrorManager.addContext(
//         "Sent setUserStreamingAccount() http request", data);
//     HttpsCallable callable =
//         FirebaseManager.functions.httpsCallable("setUserStreamingAccount");
//     final response = await callable.call(data);
//     final streamingAccountData = response.data;
//     try {
//       final decodedJson = json.decode(streamingAccountData);
//       final item = UserStreamingAccountStoreItem.fromJson(decodedJson);
//       return item;
//     } catch (e, stackTrace) {
//       ErrorManager.reportError(e, stackTrace);
//       throw StreamingAuthError(StreamingAuthErrorType.unknown);
//     }
//   }

//   /* --------- Spotify Auth ----------*/

//   Future<void> authorizeSpotify(VoidCallback successHandler,
//       Function(StreamingAuthError) failureHandler) async {
//     authSuccessHandler = successHandler;
//     authFailureHandler = failureHandler;

//     final spotifyAuthManager = SpotifyAuthManager();
//     await spotifyAuthManager.authorize(
//         _onSpotifyAuthSuccess, _onSpotifyAuthFailure);
//   }

//   void _onSpotifyAuthSuccess(String accessToken) async {
//     final data = {
//       'accountType': "spotify",
//       'spotifyAccessToken': accessToken,
//     };

//     _streamingAccount = await _setStreamingAccountForUser(data);
//     ErrorManager.addContext(
//         "Set StreamingAuthManager.streamingaccount value", streamingAccount);

//     notifyListeners();

//     authSuccessHandler();
//   }

//   void _onSpotifyAuthFailure(StreamingAuthError error) {
//     // TODO: figure out if I need to clear the existing user library account + data, etc. in backend
//     authFailureHandler(error);
//   }

//   /* --------- Apple Music Auth ----------*/

//   Future<void> authorizeAppleMusic(VoidCallback successHandler,
//       Function(StreamingAuthError) failureHandler) async {
//     authSuccessHandler = successHandler;
//     authFailureHandler = failureHandler;

//     final appleMusicAuthManager = AppleMusicAuthManager();
//     await appleMusicAuthManager.authorize(
//         _onAppleMusicAuthSuccess, _onAppleMusicAuthFailure);
//   }

//   void _onAppleMusicAuthSuccess(String accessToken) async {
//     final data = {
//       'accountType': "appleMusic",
//       'appleMusicAccessToken': accessToken,
//     };

//     await _setStreamingAccountForUser(data);
//     ErrorManager.addContext(
//         "Set StreamingAuthManager.streamingaccount value", streamingAccount);

//     notifyListeners();

//     authSuccessHandler();
//   }

//   void _onAppleMusicAuthFailure(StreamingAuthError e) async {
//     // TODO: figure out if I need to clear the existing user library account + data, etc. in backend
//     authFailureHandler(e);
//   }

//   // Fetches existing User Streaming Account from DB
//   Future<UserStreamingAccountStoreItem>
//       fetchExistingStreamingAccountItem() async {
//     // TODO: save function names in constants file
//     HttpsCallable callable = FirebaseManager.functions
//         .httpsCallable("fetchExistingStreamingAccountItem");
//     final HttpsCallableResult response = await callable.call();
//     final data = response.data;

//     // No existing authorizations found
//     if (data == null) {
//       return null;
//     }

//     try {
//       print(
//           "in fetchExistingStreamingAccountItem - before decodedJson - data: " +
//               data);
//       final decodedJson = json.decode(data);
//       if (decodedJson == null) {
//         // TODO: replace with custom error that UI can read.
//         final e = Exception("No existing streaming account found for user.");
//         ErrorManager.addContext("No existing streaming account found for user.",
//             {"userUid": _userUid});
//         return null;
//       }
//       final item = UserStreamingAccountStoreItem.fromJson(decodedJson);
//       return item;
//     } catch (e, stackTrace) {
//       ErrorManager.reportError(e, stackTrace);
//       throw StreamingAuthError(StreamingAuthErrorType.unknown);
//     }
//   }
// }
