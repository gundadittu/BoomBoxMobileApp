import 'dart:convert';

import 'package:BoomBoxApp/models/user_streaming_account_store_item.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../error_manager.dart';
import '../firebase_manager.dart';

class StreamingAccountStoreService {
  static Future<UserStreamingAccountStoreItem> setStreamingAccountForUser(
      Map<String, dynamic> data) async {
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
      throw e;
    }
  }

  // Fetches existing User Streaming Account from DB
  static Future<UserStreamingAccountStoreItem>
      fetchExistingStreamingAccountItem() async {
    // TODO: save function names in constants file
    HttpsCallable callable = FirebaseManager.functions
        .httpsCallable("fetchExistingStreamingAccountItem");
    final HttpsCallableResult response = await callable.call();
    final data = response.data;

    // No existing authorizations found
    if (data == null) {
      final e = Exception("Cloud response missing.");
      ErrorManager.reportError(e, StackTrace.current);
      throw e;
    }

    try {
      print(
          "in fetchExistingStreamingAccountItem - before decodedJson - data: " +
              data);
      final decodedJson = json.decode(data);
      if (decodedJson == null) {
        // TODO: replace with custom error that UI can read.
        final e = Exception("No existing streaming account found for user.");
        ErrorManager.addContext(
            "No existing streaming account found for user.", null);
        return null;
      }
      final item = UserStreamingAccountStoreItem.fromJson(decodedJson);
      return item;
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw e;
    }
  }
}
