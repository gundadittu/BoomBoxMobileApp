import 'package:BoomBoxApp/models/isrc_store_item.dart';
import 'package:BoomBoxApp/models/user_streaming_library_response.dart';
import 'package:BoomBoxApp/models/user_streaming_library_store_item.dart';
import 'package:flutter/material.dart';
import 'package:BoomBoxApp/error_manager.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/user_streaming_account_store_item.dart';
import './streaming_auth_manager.dart';
import '../firebase_manager.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';

// TODO: add custom errors + split up notifiers for various sections of library
class StreamingLibraryManager extends ChangeNotifier {
  UserStreamingAccountStoreItem _streamingAccount;

  UserStreamingLibraryStoreItem _streamingLibrary;
  List<IsrcStoreItem> _allLibrarySongs;
  bool _isUpdatingUserLibrary = false;
  String _userUid;

  UserStreamingAccountStoreItem get streamingAccount {
    return _streamingAccount;
  }

  bool get isUpdatingUserLibrary {
    return _isUpdatingUserLibrary;
  }

  List<IsrcStoreItem> get allLibrarySongs {
    if (_allLibrarySongs == null) {
      return [];
    }
    return _allLibrarySongs;
  }

  static final StreamingLibraryManager _singleton =
      new StreamingLibraryManager._internal();

  StreamingLibraryManager._internal() {}

  VoidCallback authSuccessHandler;
  Function(StreamingAuthError) authFailureHandler;

  factory StreamingLibraryManager() {
    StreamingLibraryManager._singleton.notifyListeners();
    return _singleton;
  }

  void update(
      String userUid, UserStreamingAccountStoreItem newStreamingAccount) {
    print("in StreamingLibraryManager.update");

    _userUid = userUid;
    if (userUid == null) {
      ErrorManager.addContext(
        "StreamingLibraryManage.update(): Returning void to null userUid provided.",
        {
          "userUid": userUid,
          "newStreamingAccount": newStreamingAccount,
          "existingStreamingAccount": _streamingAccount
        },
      );
      return;
    } else if (newStreamingAccount == null) {
      // TODO: log this + clear all values in class ??? what to do here??
      ErrorManager.addContext(
        "StreamingLibraryManage.update(): Returning void to null streaming account provided.",
        {
          "userUid": userUid,
          "newStreamingAccount": newStreamingAccount,
          "existingStreamingAccount": _streamingAccount
        },
      );
      return;
    } else if (newStreamingAccount == _streamingAccount) {
      ErrorManager.addContext(
        "StreamingLibraryManage.update(): Recieved duplicate streaming account item. Returning void.",
        {
          "userUid": userUid,
          "newStreamingAccount": newStreamingAccount,
          "existingStreamingAccount": _streamingAccount
        },
      );
      return;
    }
    updateUserStreamingLibrary();

    // populateAllLibraryData();
    // notifyListeners();
  }

  void setStreamingAccountLibraryFromResponse(
      UserStreamingLibraryResponse response) {
    _streamingLibrary = response.streamingLibraryStoreItem;
    _allLibrarySongs = response.librarySongs;
    notifyListeners();
  }

  // Triggers back-end service that fetches the user's apple music or spotify library data, such as songs, etc.
  // The back-end service returns a UserStreamingLibraryResponse object; 
  Future<void> updateUserStreamingLibrary() async {
    ErrorManager.addContext(
      "StreamingLibraryManage.updateUserStreamingLibrary(): starting.",
      {
        "userUid": _userUid,
      },
    );
    _isUpdatingUserLibrary = true;
    notifyListeners();

    try {
      HttpsCallable callable =
          FirebaseManager.functions.httpsCallable("updateUserStreamingLibrary");
      try {
        final HttpsCallableResult response = await callable.call();
        final data = response.data;
        ErrorManager.addContext(
          "StreamingLibraryManage.updateUserStreamingLibrary(): recieved response from updateUserStreamingLibrary.",
          {
            "userUid": _userUid,
            "data": data,
          },
        );

        final decodedJson = json.decode(data);
        // No existing authorizations found
        if (decodedJson == null) {
          // TODO: replace with custom error that UI can read.
          final e = Exception(
              "Missing library data. Shouldn't be happening, we just updated the library.");
          ErrorManager.reportError(e, StackTrace.current);
          throw e;
        }
        final streamingLibraryResponse =
            UserStreamingLibraryResponse.fromJson(decodedJson);

        setStreamingAccountLibraryFromResponse(streamingLibraryResponse);
      } on MissingRequiredKeysException catch (e, stackTrace) {
        ErrorManager.addContext(
            "updateUserStreamingLibrary() response missing required keys:",
            {"itemWithMissingKeys": e.map, "missingKeys": e.missingKeys});
        ErrorManager.reportError(e, stackTrace);
        // TODO: replace with custom error that UI can read.
        throw e;
      } catch (e, stackTrace) {
        ErrorManager.reportError(e, stackTrace);
        // TODO: replace with custom error that UI can read.
        throw e;
      }
    } finally {
      _isUpdatingUserLibrary = false;
      notifyListeners();
    }
  }

  Future<void> populateAllLibraryData() async {
    if (_streamingAccount == null) {
      // TODO: add proper error here?
      print("returning out of populateAllLibraryData due to null userUid");
      return;
    }
    final streamingLibraryResponse = await fetchStreamingLibraryForUser();
    // TODO: handle null casse + usually will happen when we are still fetching the user's library on backend

    setStreamingAccountLibraryFromResponse(streamingLibraryResponse);
  }

  Future<UserStreamingLibraryResponse> fetchStreamingLibraryForUser() async {
    // TODO: save function names in constants file
    HttpsCallable callable =
        FirebaseManager.functions.httpsCallable("fetchStreamingLibraryForUser");
    try {
      final HttpsCallableResult response = await callable.call();
      final data = response.data;

      // No existing authorizations found
      if (data == null) {
        return null;
      }

      final decodedJson = json.decode(data);
      final item = UserStreamingLibraryResponse.fromJson(decodedJson);
      return item;
    } on MissingRequiredKeysException catch (e, stackTrace) {
      ErrorManager.addContext(
          "fetchStreamingLibraryForUser() response missing required keys:",
          {"itemWithMissingKeys": e.map, "missingKeys": e.missingKeys});
      ErrorManager.reportError(e, stackTrace);
      throw e;
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw e;
    }
  }
}
