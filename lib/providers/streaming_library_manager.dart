import 'package:BoomBoxApp/models/isrc_store_item.dart';
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
  UserStreamingAccountStoreItem streamingAccount;
  List<IsrcStoreItem> _allLibrarySongs;

  static final StreamingLibraryManager _singleton =
      new StreamingLibraryManager._internal();

  StreamingLibraryManager._internal() {}

  VoidCallback authSuccessHandler;
  Function(StreamingAuthError) authFailureHandler;

  factory StreamingLibraryManager() {
    StreamingLibraryManager._singleton.notifyListeners();
    return _singleton;
  }

  List<IsrcStoreItem> get allLibrarySongs {
    if (_allLibrarySongs == null) {
      return [];
    }
    return _allLibrarySongs;
  }

  void update(UserStreamingAccountStoreItem streamingAccount) {
    streamingAccount = streamingAccount;
    if (streamingAccount == null) {
      // TODO: log this + clear all values in class
      return;
    }
    // populateAllLibraryData();
    notifyListeners();
  }

  Future<void> populateAllLibraryData() async {
    print("populateAllLibraryData() starting");
    final userStreamingLibraryStoreItem = await fetchStreamingLibraryForUser();
    // TODO: handle null casse + usually will happen when we are still fetching the user's library on backend

    _allLibrarySongs = userStreamingLibraryStoreItem.librarySongs;
    notifyListeners();
  }

  Future<UserStreamingLibraryStoreItem> fetchStreamingLibraryForUser() async {
    print("fetchStreamingLibraryForUser() starting");
    // TODO: save function names in constants file
    HttpsCallable callable =
        FirebaseManager.functions.httpsCallable("fetchStreamingLibraryForUser");
    final HttpsCallableResult response = await callable.call();
    print(response.data);
    final data = response.data;
    print("fetchStreamingLibraryForUser() got data");

    // No existing authorizations found
    if (data == null) {
      return null;
    }

    try {
      final decodedJson = json.decode(data);
      final item = UserStreamingLibraryStoreItem.fromJson(decodedJson);
      print("fetchStreamingLibraryForUser() AFTER json.decode");
      print(item);
      return item;
    } on MissingRequiredKeysException catch (e, stackTrace) {
      ErrorManager.addContext("fetchStreamingLibraryForUser() response missing required keys:", {"itemWithMissingKeys": e.map, "missingKeys": e.missingKeys});
      ErrorManager.reportError(e, stackTrace);
      throw e; 
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw e;
    }
  }
}
