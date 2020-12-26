import 'package:BoomBoxApp/error_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../provider/streaming_auth_manager.dart';
import '../error_manager.dart';

// if (hasPlaybackCapability) {
//    testAppleMusicPlayer();
// }
// Future<bool> testAppleMusicPlayer() async {
//   print("in testAppleMusicPlayer");
//   final songIDList = ["900032829"];
//   final playStatus = await platform.invokeMethod('playAppleMusicTest', [songIDList]);
//   print("playStatus is $playStatus");
// }

class AppleMusicAuthManager {
  static const platform =
      const MethodChannel('streaming.boombox.app/apple-music');
  String storeFrontCountryCode;
  String userToken;
  // accountAuthorized indicates whether the app is authorized to access the user's account
  bool accountAuthorized = false;
  bool hasPlaybackCapability = false;
  bool eligibleForSubscription = false;
  bool canAddtoCloudMusicLibrary = false;

  Future<void> authorize() async {
    if (!Platform.isIOS) {
      throw StreamingAuthError(
          StreamingAuthErrorType.incompatibleDevicePlatform);
    }

    await _requestAccountAuthorization();

    await _requestCapabilities();

    await _requestUserToken();

    await _requestStorefrontCountryCode();
  }

  // https://developer.apple.com/documentation/storekit/skcloudservicecontroller/2909079-requestusertoken
  Future<void> _requestUserToken() async {
    try {
      userToken = await platform.invokeMethod('requestAppleMusicUserToken');
      ErrorManager.addContext("Received Apple Music user token", userToken);
      if (userToken == null) {
        throw Error();
      }
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
  }

  // https://developer.apple.com/documentation/storekit/skcloudservicecontroller/2909076-requeststorefrontcountrycode
  Future<void> _requestStorefrontCountryCode() async {
    try {
      storeFrontCountryCode =
          await platform.invokeMethod('requestAppleMusicStorefrontCountryCode');
      ErrorManager.addContext(
          "Recieved storeFrontCountryCode", storeFrontCountryCode);
    } catch (e, stackTrace) {
      storeFrontCountryCode = null;
      ErrorManager.reportError(e, stackTrace);
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
  }

  Future<void> _requestAccountAuthorization() async {
    try {
      // status int values come from here: https://developer.apple.com/documentation/storekit/skcloudserviceauthorizationstatus
      void _handleAuthorizationStatus(int status) {
        if (status == 0) {
          // Authorization not determined
          accountAuthorized = false;
          return;
        } else if (status == 1) {
          // Authorization denied
          accountAuthorized = false;
          throw StreamingAuthError(StreamingAuthErrorType.deniedByUser);
        } else if (status == 2) {
          // Authorization restricted
          accountAuthorized = false;
          throw StreamingAuthError(StreamingAuthErrorType.incompatibleAccount);
        } else if (status == 3) {
          accountAuthorized = true;
          return;
        }
      }

      int authorizationStatus = await _getUserAuthorizationStatus();
      ErrorManager.addContext(
          "Recieved apple music authorization status:", authorizationStatus);

      // Updates class authorization status and throws errors if authorization is denied or restricted
      _handleAuthorizationStatus(authorizationStatus);

      // Account already authorized
      if (accountAuthorized) {
        return;
      }

      int accountAuthorizedResponse =
          await platform.invokeMethod('requestAppleMusicAuthorization');
      ErrorManager.addContext("Recieved apple music authorization status:",
          accountAuthorizedResponse);

      // Throws errors if authorization is denied or restricted
      _handleAuthorizationStatus(authorizationStatus);
    } catch (e, stackTrace) {
      accountAuthorized = false;
      ErrorManager.reportError(e, stackTrace);
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
  }

// https://developer.apple.com/documentation/storekit/skcloudservicecontroller/1620610-requestcapabilities
  Future<void> _requestCapabilities() async {
    try {
      final List<dynamic> capabilityList =
          await platform.invokeMethod('requestAppleMusicCapabilities');
      ErrorManager.addContext(
          "Recieved apple music capabilities:", capabilityList);

      hasPlaybackCapability = capabilityList[0];
      eligibleForSubscription = capabilityList[1];
      canAddtoCloudMusicLibrary = capabilityList[2];
    } catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
  }

  Future<int> _getUserAuthorizationStatus() async {
    // Returns int values: https://developer.apple.com/documentation/storekit/skcloudserviceauthorizationstatus
    // .notDetermined = 0
    // .denied = 1
    // .restricted = 2
    // .authorized = 3
    try {
      final int authorizationStatus =
          await platform.invokeMethod('isUserAuthorizedWithAppleMusic');
      return authorizationStatus;
    } on Exception catch (e, stackTrace) {
      ErrorManager.reportError(e, stackTrace);
      throw StreamingAuthError(StreamingAuthErrorType.unknown);
    }
  }
}
